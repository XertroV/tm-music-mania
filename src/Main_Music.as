// GM = Global Music

MusicOrSound@ GM_Menu;
MusicOrSound@ GM_InGame;
MusicOrSound@ GM_Editor;
// todo: sounds
MusicOrSound@ GM_InGameSounds;
MusicOrSound@ GM_EditorSounds;

enum MusicCtx {
    InGame,
    Menu,
    Editor
}

namespace Music {
    void Main() {
        // todo: instantiating music in the wrong mania app context can cause problems where it doesn't play back properly and things get stuck.
        // todo: we shouldn't create this until we're in the menu.
        // if (TM_State::IsInMenu) {
        //     ChooseInMenuMusic();
        // }
        startnew(Music::MainInGameLoop).WithRunContext(Meta::RunContext::GameLoop);
    }

    // safe to pass null to disable game sounds
    void SetGameSoundPack(AudioPack@ pack) {
        if (Packs::UpdateGameSoundsChoice(pack) && TM_State::IsInPlayground) {
            dev_trace("UpdateGameSoundsChoice: Game sounds changed");
            if (GM_InGameSounds !is null) GM_InGameSounds.CleanUp();
            if (pack is null) {
                @GM_InGameSounds = null;
            } else {
                @GM_InGameSounds = cast<GameSounds>(pack.ToMusicOrSound());
            }
        }
    }

    void SetCurrentMusicChoice(AudioPack@ music) {
        if (TM_State::IsInMenu) {
            if (Packs::UpdateMenuMusicChoice(music)) {
                dev_trace("UpdateMenuMusicChoice: Menu music changed");
                if (GM_Menu !is null) {
                    GM_Menu.CleanUp();
                    @GM_Menu = null;
                }
                ChooseInMenuMusic();
            } else {
                dev_trace("UpdateMenuMusicChoice: Menu music unchanged");
            }
        } else if (TM_State::IsInPlayground) {
            if (Packs::UpdateInGameMusicChoice(music)) {
                dev_trace("UpdateInGameMusicChoice: InGame music changed");
                if (GM_InGame !is null) {
                    GM_InGame.CleanUp();
                    @GM_InGame = null;
                }
                ChooseInGameMusic(false);
            } else {
                dev_trace("UpdateInGameMusicChoice: InGame music unchanged");
            }
        } else if (TM_State::IsInEditor) {
            if (Packs::UpdateEditorMusicChoice(music)) {
                dev_trace("UpdateEditorMusicChoice: Editor music changed");
                if (GM_Editor !is null) {
                    GM_Editor.CleanUp();
                    @GM_Editor = null;
                }
                ChooseEditorMusic();
            } else {
                dev_trace("UpdateEditorMusicChoice: Editor music unchanged");
            }
        } else {
            dev_warn("SetCurrentMusicChoice: not in a valid context");
        }
    }

    void ReloadMusicFor(MusicCtx ctx) {
        switch (ctx) {
            case MusicCtx::InGame:
                if (GM_InGame !is null) GM_InGame.CleanUp();
                if (GM_InGameSounds !is null) GM_InGameSounds.CleanUp();
                @GM_InGame = null;
                @GM_InGameSounds = null;
                break;
            case MusicCtx::Menu:
                if (GM_Menu !is null) GM_Menu.CleanUp();
                @GM_Menu = null;
                break;
            case MusicCtx::Editor:
                if (GM_Editor !is null) GM_Editor.CleanUp();
                @GM_Editor = null;
                break;
        }
    }

    MusicOrSound@ GetCurrentMusic() {
        if (TM_State::IsInMenu) return GM_Menu;
        if (TM_State::IsInPlayground) return GM_InGame;
        if (TM_State::IsInEditor) return GM_Editor;
        return null;
    }

    string GetCurrentMusicPackName() {
        auto music = GetCurrentMusic();
        if (music is null) return "null";
        return music.GetOriginName();
    }

    string GetCurrentGameSoundPackName() {
        auto music = GetCurrentGameSounds();
        if (music is null) return "null";
        return music.GetOriginName();
    }

    MusicOrSound@ GetCurrentGameSounds() {
        if (TM_State::IsInPlayground) return GM_InGameSounds;
        return null;
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
            if (GM_InGame !is null) GM_InGame.CleanUp();
            if (GM_InGameSounds !is null) GM_InGameSounds.CleanUp();
            if (GM_Editor !is null) GM_Editor.CleanUp();
            if (GM_EditorSounds !is null) GM_EditorSounds.CleanUp();
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
        dev_warn("Choosing menu music");
        if (GM_Menu !is null) GM_Menu.CleanUp();
        @GM_Menu = Packs::GetMenuMusic().ToMusicOrSound();
        return GM_Menu;
    }

    MusicOrSound@ ChooseEditorMusic() {
        if (GM_Editor !is null) GM_Editor.CleanUp();
        if (GM_EditorSounds !is null) GM_EditorSounds.CleanUp();
        @GM_Editor = Packs::GetEditorMusic().ToMusicOrSound();
        @GM_EditorSounds = null;
        return GM_Editor;
    }

    MusicOrSound@ ChooseInGameMusic(bool andGameSounds = true) {
        if (GM_InGame !is null) GM_InGame.CleanUp();
        if (TM_State::MapHasEmbeddedMusic && GameMusic::S_PrioritizeMusicInMap) {
            // do nothing if the map has music and we want to prioritize it.
        } else {
            @GM_InGame = Packs::GetInGameMusic().ToMusicOrSound();
        }

        if (andGameSounds) {
            if (GM_InGameSounds !is null) GM_InGameSounds.CleanUp();
            @GM_InGameSounds = Packs::GetInGame_GameSounds().ToMusicOrSound();
        }
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
            if (GM_InGame is null && GM_InGameSounds is null && TM_State::IsInPlayground) {
                yield();
                continue;
            }

            if (!TM_State::IsInPlayground) break;

            // monitor for spawns, finishes, cps, etc.
            RaceStateMonitor.Update(app);
            if (GM_InGame !is null) GM_InGame.UpdateRace(RaceStateMonitor);
            if (GM_InGameSounds !is null) GM_InGameSounds.UpdateRace(RaceStateMonitor);

            yield();
        }
        @RaceStateMonitor = null;
        dev_warn("Exited InGameLoop");
    }

    void RenderMenuMain() {
        if (UI::BeginMenu(MenuMainTitle)) {
            RenderMenu_CurrentMusicStats();

            if (TM_State::MapHasEmbeddedMusic) {
                UI::SeparatorText("Map Music");

                auto map = GetApp().RootMap;
                auto plugSound = map.CustomMusic;
                auto musicPackDesc = map.CustomMusicPackDesc;

                if (plugSound !is null) {
                    plugSound.VolumedB = UI::SliderFloat("Map music vol dB", plugSound.VolumedB, -40., 12.);
                }

                if (musicPackDesc !is null) {
                    UI::Text("Pack.Name: " + musicPackDesc.Name);
                    UI::Text("Pack.Url: " + musicPackDesc.Url);
                    auto fid = musicPackDesc.Fid;
                    if (fid !is null) {
                        if (fid.Nod !is null) {
                            auto nodTy = Reflection::TypeOf(fid.Nod);
                            UI::Text("Nod Type: " + nodTy.Name);
                            UI::Text("BaseType: " + nodTy.BaseType.Name);
                        }
                    }
                }
            }

            UI::SeparatorText("\\$8f8\\$iAvailable Packs");
            RenderMenu_ListPacks();
            UI::SeparatorText("Settings");
            RenderMenu_Settings();
            UI::EndMenu();
        }
    }

    void RenderMenu_CurrentMusicStats() {
        UI::SeparatorText("Global Volumes");

        // UI::PushItemWidth(200.);
        Global::MusicVolume = UI::SliderFloat("Music Vol dB", Global::MusicVolume, -40., 6.);
        Global::GameVolume = UI::SliderFloat("Game Vol dB", Global::GameVolume, -40., 6.);
        // UI::PopItemWidth();

        UI::SeparatorText("Music");

        UI::BeginDisabled();
        UI::MenuItem("Current Pack: " + GetCurrentMusicPackName());
        if (TM_State::IsInPlayground) {
            UI::MenuItem("\\$i   Game Sounds: " + (GM_InGameSounds is null ? "null" : GM_InGameSounds.GetOriginName()));
        }
        UI::EndDisabled();

        auto curMusic = GetCurrentMusic();
        if (curMusic !is null) {
            curMusic.RenderMenuTools();
        }
    }

    void RenderMenu_ListPacks() {
        bool listInGame = TM_State::IsInPlayground;
        bool listEditor = !listInGame && TM_State::IsInEditor;
        bool listMenu = TM_State::IsInMenu;
        // int flags = listInGame ? (AudioPackType::Loops_Turbo | AudioPackType::Playlist | AudioPackType::GameSounds)
        //     : listEditor ? (AudioPackType::Loops_Editor | AudioPackType::Playlist)
        //     : listMenu ? (AudioPackType::Playlist) : 0;

        UI::BeginDisabled(!listInGame);
        if (UI::BeginMenu("InGame Music (Loops)")) {
            RenderMenu_ListPack(Packs::LoopsTurbo);
            UI::EndMenu();
        }
        if (UI::BeginMenu("InGame Music (Playlists)")) {
            RenderMenu_ListPack(Packs::Playlists);
            UI::EndMenu();
        }
        if (UI::BeginMenu("Game Sounds")) {
            RenderMenu_ListPack(Packs::GameSounds, true);
            UI::EndMenu();
        }
        UI::EndDisabled();

        UI::BeginDisabled(!listEditor);
        if (UI::BeginMenu("Editor Music (Loops)")) {
            RenderMenu_ListPack(Packs::EditorLoops);
            UI::EndMenu();
        }
        if (UI::BeginMenu("Editor Music (Playlists)")) {
            RenderMenu_ListPack(Packs::Playlists);
            UI::EndMenu();
        }
        UI::EndDisabled();

        UI::BeginDisabled(!listMenu);
        if (UI::BeginMenu("Menu Music")) {
            RenderMenu_ListPack(Packs::Playlists);
            UI::EndMenu();
        }
        UI::EndDisabled();
    }

    void RenderMenu_ListPack(AudioPack@[]@ packs, bool includeNull = false, bool isGameSounds = true) {
        if (packs.Length == 0) {
            UI::Text("No packs here :(");
            return;
        }

        if (includeNull) {
            if (UI::MenuItem("\\$bbb<None>", "", GetCurrentGameSounds() is null)) {
                if (isGameSounds) SetGameSoundPack(null);
                else SetCurrentMusicChoice(null);
            }
        }

        for (uint i = 0; i < packs.Length; i++) {
            packs[i].RenderSongChoiceMenu();
        }
    }

    void RenderMenu_Settings() {
        UX::PushThinControls();
        S_Playlist_RepeatOne = UI::Checkbox("[Playlist] Repeat One", S_Playlist_RepeatOne);
        AddSimpleTooltip("When enabled, the playing track will loop until the map changes.\nOtherwise, when a track finishes, a new track will play.");
        S_Playlist_Sequential = UI::Checkbox("[Playlist] Sequential", S_Playlist_Sequential);
        AddSimpleTooltip("When enabled, the playlist will advance through the tracks in order. Otherwise, it will play them randomly.");

        UI::Separator();

        GameMusic::S_PrioritizeMusicInMap = UI::Checkbox("[General] Prioritize embedded music", GameMusic::S_PrioritizeMusicInMap);
        AddSimpleTooltip("When enabled, music embedded in a map will play instead of music from the current pack.");
        GameMusic::S_SetMusicInMapVolume = UI::Checkbox("[General] Set volume on embedded music", GameMusic::S_SetMusicInMapVolume);
        AddSimpleTooltip("When enabled, the volume of embedded music will be adjusted.");
        if (GameMusic::S_SetMusicInMapVolume) {
            UI::SetNextItemWidth(120.);
            GameMusic::S_MusicInMapVolume = UI::SliderFloat("[General] Embedded music v. dB", GameMusic::S_MusicInMapVolume, -40., 6.);
            AddSimpleTooltip("Default: 0.0 dB. Suggested: 6.0 dB.\nCtrl+click to input exact values.");
        }

        UI::Separator();

        LittleWindow::S_ShowLittleWindow = UI::Checkbox("[UI] Show Little Window", LittleWindow::S_ShowLittleWindow);

        UX::PopThinControls();
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
