// GM = Global Music

MusicOrSound@ GM_Menu;
MusicOrSound@ GM_InGame;
MusicOrSound@ GM_Editor;
// todo: sounds
MusicOrSound@ GM_InGameSounds;
MusicOrSound@ GM_EditorSounds;

namespace Music {
    void Main() {
        // todo: instantiating music in the wrong mania app context can cause problems where it doesn't play back properly and things get stuck.
        // todo: we shouldn't create this until we're in the menu.
        if (TM_State::IsInMenu) {
            ChooseInMenuMusic();
        }
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
        // we need the game to load its music first so we can replace it
        yield(4);
        dev_trace("Resetting due to context change. IsInMenu: " + TM_State::IsInMenu + ", IsInPlayground: " + TM_State::IsInPlayground + ", IsInEditor: " + TM_State::IsInEditor);
        startnew(GameMusic::Reset);
        yield(4);

        if (TM_State::IsInMenu) {
            @GM_InGame = null;
            @GM_InGameSounds = null;
            @GM_Editor = null;
            @GM_EditorSounds = null;

            if (GM_Menu is null) ChooseInMenuMusic();
            else GM_Menu.OnContextEnter();

            startnew(Music::InMenuLoop).WithRunContext(Meta::RunContext::GameLoop);
        } else if (TM_State::IsInPlayground) {
            // we need the game to load its music first so we can replace it
            // yield(10);

            if (GM_InGame is null) ChooseInGameMusic();
            else GM_InGame.OnContextEnter();
            startnew(Music::InGameLoop).WithRunContext(Meta::RunContext::AfterMainLoop);
        } else if (TM_State::IsInEditor) {
            @GM_InGame = null;
            @GM_InGameSounds = null;
            if (GM_Editor is null) ChooseEditorMusic();
            else GM_Editor.OnContextEnter();
        } else if (TM_State::IsLoading) {
            // do nothing...
        }
    }

    MusicOrSound@ ChooseInMenuMusic() {
        // todo: apply settings here when choosing menu music
        dev_warn("Choosing menu music");
        @GM_Menu = Packs::GetMenuMusic().ToMusicOrSound();
        return GM_Menu;
    }

    MusicOrSound@ ChooseEditorMusic() {
        @GM_Editor = Packs::GetEditorMusic().ToMusicOrSound();
        return GM_Editor;
    }

    MusicOrSound@ ChooseInGameMusic() {
        // todo: @GM_InGame =
        @GM_InGame = Packs::GetInGameMusic().ToMusicOrSound();
        @GM_InGameSounds = Packs::GetInGame_GameSounds().ToMusicOrSound();
        return GM_InGame;
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
        @RaceStateMonitor = null;
        dev_warn("Exited InGameLoop");
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
        // curPg.Arena.MapLandmarks[playerCpIx].Waypoint.IsFinish
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
