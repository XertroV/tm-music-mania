// GM = Global Music

MusicOrSound@ GM_Menu;
MusicOrSound@ GM_InGame;
MusicOrSound@ GM_Editor;
// todo: sounds
MusicOrSound@ GM_InGameSounds;
MusicOrSound@ GM_EditorSounds;

namespace Music {
    void Main() {
        @GM_Menu = Music_TurboInMenu();
        startnew(Music::MainInGameLoop).WithRunContext(Meta::RunContext::GameLoop);
    }

    void MainInGameLoop() {
        while (true) {
            TM_State::RunUpdate();
            if (TM_State::ContextChanged) {
                OnGameContextChanged();
            }
            yield();
        }
    }

    void OnGameContextChanged() {
        if (TM_State::IsInMenu) {
            @GM_InGame = null;
            @GM_InGameSounds = null;
            @GM_Editor = null;
            @GM_EditorSounds = null;
            GM_Menu.OnContextEnter();
            startnew(Music::InMenuLoop).WithRunContext(Meta::RunContext::GameLoop);
        } else if (TM_State::IsInPlayground) {

            GM_Menu.OnContextLeave();
            if (GM_Editor !is null) GM_Editor.OnContextLeave();

            if (GM_InGame is null) ChooseInGameMusic();
            else GM_InGame.OnContextEnter();

            startnew(Music::InGameLoop).WithRunContext(Meta::RunContext::GameLoop);

        } else if (TM_State::IsInEditor) {
            GM_Menu.OnContextLeave();
            if (GM_Editor is null) ChooseEditorMusic();
            else GM_Editor.OnContextEnter();
        } else if (TM_State::IsLoading) {
            // do nothing...
        }
    }

    void ChooseEditorMusic() {
        // todo: @GM_Editor =
    }

    void ChooseInGameMusic() {
        // todo: @GM_InGame =
        @GM_InGame = Music_TurboInGame();
        @GM_InGameSounds = GameSounds_Turbo();
    }

    void InMenuLoop() {
        yield();
        while (TM_State::IsInMenu) {
            GM_Menu.Update();
            yield();
        }
    }

    InGameRaceStateMonitor@ RaceStateMonitor;

    void InGameLoop() {
        yield();
        auto app = cast<CTrackMania>(GetApp());
        // should always hit this
        if (RaceStateMonitor is null) {
            @RaceStateMonitor = InGameRaceStateMonitor();
        }
        // -- main loop --
        while (TM_State::IsInPlayground) {
            // wait for music to be loaded if there is no selection
            if (GM_InGame is null && GM_InGameSounds is null) {
                yield();
                continue;
            }

            // monitor for spawns, finishes, cps, etc.
            RaceStateMonitor.Update(app);
            if (GM_InGame !is null) GM_InGame.UpdateRace(RaceStateMonitor);
            if (GM_InGameSounds !is null) GM_InGameSounds.UpdateRace(RaceStateMonitor);

            yield();
        }
    }
}





class InGameRaceStateMonitor {
    Turbo::ERaceState RaceState = Turbo::ERaceState::BeforeStart;
    Turbo::ERaceState Last_RaceState = Turbo::ERaceState::Eliminated;
    bool RaceStateChanged = false;

    int m_latestCheckpointForPlayers = -1;
    int m_raceStateTrigger_Finished = -1;
    bool m_isLastFinished = false;

    float m_cutoffSpeedThreshold = 175.;
    bool m_isQuick = false;
    bool m_isPaused = false;
    bool m_freewheelTrackNeeded = false;
    bool m_switchTrackNeeded = false;
    bool m_lapTrackNeeded = false;
    bool m_StartStandbyNeeded = false;
    bool m_StartReplayNeeded = false;
    bool m_StopMusicNeeded = false;

    // update each frame
    bool isEngineOff = false;
    bool wasEngineOff = false;
    uint playerCpIx = 0xFFFFFFFF;
    uint lastPlayerCpIx = 0xFFFFFFFF;
    uint playerLapCount = 0;
    uint lastPlayerLapCount = 0;
    bool playerRespawned = false;
    bool lastPlayerWasFinished = false;
    bool didFinishThisFrame = false;
    bool cpsChanged = false;
    int cpTakenThisFrame = -1;
    bool cpThisFrameWasFast = false;
    int cpsTaken = -1;
    int bestCpTimeForCurrentCp = 0xFFFFFFFF;
    bool playerRespawnedThisFrame = false;
    bool startedThisFrame = false;
    int curRaceTime;

    InGameRaceStateMonitor() {}

    // MARK: - Update

    void Update(CTrackMania@ app) {
        auto curPg = cast<CSmArenaClient>(app.CurrentPlayground);
        RaceState = GetCurRaceState(curPg);
        RaceStateChanged = RaceState != Last_RaceState;
        Last_RaceState = RaceState;

        CarSpeed = 0.;
        cpTakenThisFrame = -1;

        switch (RaceState) {
            case Turbo::ERaceState::BeforeStart:
            case Turbo::ERaceState::Eliminated:
                m_latestCheckpointForPlayers = -1;
                m_isLastFinished = false;
        }

        if (RaceStateChanged) {
            if (RaceState == Turbo::ERaceState::EndRound) {
                m_StartStandbyNeeded = true;
            }
        }

        if (curPg is null || curPg.GameTerminals.Length == 0) {
            return;
        }

        CSmPlayer@ player = cast<CSmPlayer>(curPg.GameTerminals[0].ControlledPlayer);
        if (player is null) {
            return;
        }
        auto playerScript = cast<CSmScriptPlayer>(player.ScriptAPI);

        playerCpIx = player.CurrentLaunchedRespawnLandmarkIndex;
        playerLapCount = playerScript.CurrentLapNumber;
        curRaceTime = TM_State::InPg_GameTime < 0 ? -1500 : TM_State::InPg_GameTime - playerScript.StartTime;
        if (playerScript.RaceWaypointTimes.Length > 0) {
            throw("RaceWaypointTimes.Length > 0: " + playerScript.RaceWaypointTimes.Length + " / " + playerScript.RaceWaypointTimes[playerScript.RaceWaypointTimes.Length - 1]);
        }
        // last frame curRaceTime was < 0, so this is the first frame we can move
        startedThisFrame = playerRespawned && curRaceTime >= 0;
        playerRespawnedThisFrame = !playerRespawned;
        playerRespawned = curRaceTime < 0;
        playerRespawnedThisFrame = playerRespawnedThisFrame && playerRespawned;

        player.EndTime > 0
        if (TM_State::InPg_IsUiFinish) m_isLastFinished = true;
        else if (TM_State::InPg_IsUiPlaying) m_isLastFinished = false;

        didFinishThisFrame = !lastPlayerWasFinished && m_isLastFinished;
        cpsChanged = playerCpIx != lastPlayerCpIx; // hmm?    && !playerRespawned;

        if (playerRespawned || startedThisFrame) {
            cpsTaken = -1;
        }

        if (cpsChanged) {
            cpTakenThisFrame = ++cpsTaken;
            bestCpTimeForCurrentCp = (cpsTaken < 0 || player.Score.BestRaceTimes.Length <= cpsTaken) ? 0xFFFFFFFF : player.Score.BestRaceTimes[cpsTaken];
            cpThisFrameWasFast = curRaceTime < bestCpTimeForCurrentCp;

            if (playerLapCount != lastPlayerLapCount && playerLapCount > 0) {
                m_lapTrackNeeded = true;
            } else if (!didFinishThisFrame && RaceState == Turbo::ERaceState::Running) {
                if (!playerRespawned) {
                    m_latestCheckpointForPlayers = playerCpIx;
                    m_switchTrackNeeded = true;
                }
            }
        }

        if (didFinishThisFrame) {
            // reset cps
            cpsTaken = -1;
            // update flags
            m_raceStateTrigger_Finished = TM_State::InPg_GameTime;
            m_switchTrackNeeded = true;
            // finish sound handled in game sounds by checking didFinishThisFrame
        }

        lastPlayerCpIx = playerCpIx;
        lastPlayerLapCount = playerLapCount;
        lastPlayerWasFinished = m_isLastFinished;

        // MARK: - vehicle & speed

        CSceneVehicleVis@ vis = VehicleState::GetVis(app.GameScene, player);
        if (vis !is null) {
            // why doesn't EngineOn work? :(
            isEngineOff = Dev::GetOffsetUint8(vis.AsyncState, 0x1B9) == 1;
            // isEngineOff = !vis.AsyncState.EngineOn;
            if (isEngineOff != wasEngineOff) {
                wasEngineOff = isEngineOff;
                // update music
                if (isEngineOff) {
                    dev_warn("Monitor!! engine off");
                    m_freewheelTrackNeeded = true;
                }
                else m_switchTrackNeeded = true;
            }
            CarSpeed = vis.AsyncState.WorldVel.Length() * 3.6;
        }
    }

    float CarSpeed = 0.;


    Turbo::ERaceState GetCurRaceState(CSmArenaClient@ curPg) {
        if (curPg is null) return Turbo::ERaceState::BeforeStart;
        switch (EUiSeq(TM_State::InPg_UiSeq)) {
            case EUiSeq::EndRound: return Turbo::ERaceState::Finished;
            case EUiSeq::Finish: return Turbo::ERaceState::Running;
            case EUiSeq::Intro: return Turbo::ERaceState::Finished;
            case EUiSeq::Playing: return Turbo::ERaceState::Running;
        }
        return Turbo::ERaceState::Running;
    }
}



// Matches SGamePlaygroundUIConfig::EUISequence
enum EUiSeq {
    None = 0,
    Playing = 1,
    Intro,
    Outro,
    Podium,
    CustomMTClip,
    EndRound,
    PlayersPresentation,
    UIInteraction,
    RollingBackgroundIntro,
    CustomMTClip_WithUIInteraction,
    Finish = 11
}
