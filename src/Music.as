// Music scopes: menu, editor, game


class MusicOrSound {
    string name;
    AudioPack@ origin;

    MusicOrSound(const string &in name) {
        this.name = name;
        dev_trace("MusicOrSound Created: " + name);
        // if (name.EndsWith("/")) {
        //     dev_warn("MusicOrSound Created: " + name);
        //     PrintActiveContextStack();
        // }
    }
    ~MusicOrSound() {
        dev_trace("MusicOrSound Destroyed: " + name);
        CleanUp();
        dev_trace("MusicOrSound Cleaned up: " + name);
    }
    void Update() {}
    void UpdateRace(InGameRaceStateMonitor@ raceState) {}
    void CleanUp() {
        throw("CleanUp not implemented for " + name);
    }

    void OnStart() {}
    void OnFinish() {}
    void OnCheckpoint(int cpCount, bool fast) {}
    void OnLap(int lapCount) {}
    void OnFreewheel() {}

    void OnContextEnter() {}
    void OnContextLeave() {}

    void RenderDebug() {}

    string GetOriginName() {
        if (origin is null) return "null";
        return origin.name;
    }

    void RenderMenuTools() {
        UI::TextWrapped("\\$f00\\$i implement RenderMenuTools for " + name + " (Origin: " + GetOriginName() + ")");
    }

    int GetCurrTrackIx() {
        return -1;
    }

    string GetCurrTrackName() {
        throw("GetCurrTrackName not implemented for " + name);
        return "No track";
    }

    string GetTimeProgressString() {
        throw("GetTimeProgressString not implemented for " + name);
        return "0:00 / 0:00";
    }
}

// Manages turbo-like music (tracks and loops) in-game
class Music_TurboInGame : MusicOrSound {
    // 'all' excluding standby and replay
    CAudioScriptMusic@ CurMusic;
    CAudioScriptMusic@[] MusicAll;
    // CAudioScriptSound@[] MusicStandby;
    CAudioScriptSound@ MusicStandby;
    CAudioScriptSound@ MusicReplay;

    Json::Value@[] G_MusicDescs;

    int G_PrevPlayedTrack = -1;
    int[] G_MusicRandomIndice;

    string G_Debug_SongName;
    int G_MusicDelay = 0;
    float G_MusicGain = 0.0;
    float G_Debug_LastTargetLPFratioFromSpeed = 0.0;

    Music_TurboInGame(Json::Value@ musicList = null) {
        super("Turbo In-Game Music");
        InitRandomMusicIndicies();
        PreloadAllMusicAndSounds();
        // for custom music lists
        @_musicList = musicList;
    }

    Music_TurboInGame@ WithOriginPack(AudioPack@ origin) {
        @this.origin = origin;
        return this;
    }

    private Json::Value@ _musicList;
    Json::Value@ GetMusicList() {
        if (_musicList is null) return TurboMusicList;
        return _musicList;
    }

    void RenderDebug() override {
        UI::Text("G_Debug_SongName: " + G_Debug_SongName);
        UI::Text("G_Debug_LastTargetLPFratioFromSpeed: " + G_Debug_LastTargetLPFratioFromSpeed);
    }

    void CleanUp() override {
        auto audio = GetAudio();
        CleanupMusics(audio, MusicAll);
        // CleanupMusics(audio, MusicStandby);
        CleanupSound(audio, MusicStandby);
        CleanupSound(audio, MusicReplay);
        @MusicStandby = null;
        @MusicReplay = null;
        @CurMusic = null;
    }

    void UpdateRace(InGameRaceStateMonitor@ raceState) override {
        if (raceState.didFinishThisFrame) OnFinish();
        else if (raceState.startedThisFrame) OnStart();
        else if (raceState.cpTakenThisFrame >= 0) {
            OnCheckpoint(raceState.cpTakenThisFrame, raceState.cpThisFrameWasFast);
        }
        UpdateRaceStateGeneral(raceState);
    }

    void UpdateRaceStateGeneral(InGameRaceStateMonitor@ raceState) {
        switch (raceState.RaceState) {
            case Turbo::ERaceState::BeforeStart:
            case Turbo::ERaceState::Eliminated: {
                ResetSounds(false);
            }
        }

        if (raceState.RaceStateChanged) {
            switch (raceState.RaceState) {
                case Turbo::ERaceState::BeforeStart:
                case Turbo::ERaceState::Eliminated:
                    MusicReplay.Stop();
                    break;
                case Turbo::ERaceState::Running:
                    dev_trace("RaceStateChanged to Running");
                    // SetSFXSceneLevel();
                    PickNewMusicTrack();
                    break;
            }
        } else if (raceState.playerRespawnedThisFrame) {
            if (raceState.RaceState == Turbo::ERaceState::Running) {
                PickNewMusicTrack();
            }
        }

        if (raceState.m_StartStandbyNeeded) {
            raceState.m_StartStandbyNeeded = false;
            CurMusic.Stop();
            MusicReplay.Stop();
            MusicStandby.VolumedB = Turbo::VolumedB_MusicStandBy;
            MusicStandby.Play();
        }

        if (raceState.m_StartReplayNeeded) {
            raceState.m_StartReplayNeeded = false;
            CurMusic.Stop();
            MusicStandby.Stop();
            MusicReplay.VolumedB = Turbo::VolumedB_MusicReplay;
            MusicReplay.Play();
        }

        if (raceState.m_StopMusicNeeded) {
            raceState.m_StopMusicNeeded = false;
            // if (MusicStandby.IsPlaying && SoundStandbyEvent !is null) {
            //     trace("Music: Standby event");
            //     audio.PlaySoundEvent(SoundStandbyEvent, GetVolumedB("MusicReplay"));
            // }
            CurMusic.Stop();
            MusicStandby.Stop();
            MusicReplay.Stop();
        }

        if (raceState.m_switchTrackNeeded) {
            raceState.m_switchTrackNeeded = false;
            CurMusic.EnableSegment("loop");
            CurMusic.NextVariant();
        }

        if (raceState.m_freewheelTrackNeeded) {
            raceState.m_freewheelTrackNeeded = false;
            CurMusic.EnableSegment("freewheel");
        }

        if (raceState.m_lapTrackNeeded) {
            raceState.m_lapTrackNeeded = false;
            // CurMusic.EnableSegment("lap");
            CurMusic.EnableSegment("loop");
            CurMusic.NextVariant();
        }

        UpdateLPF(raceState);
    }

    void PickNewMusicTrack(int musicIx = -1) {
        auto loadedMusicIx = EnsureMusicIxLoadedAndGetIx(musicIx);
        LoadMusic(loadedMusicIx);
        ResetSounds(true);
        OnStartRace_Reset();
    }

    int EnsureMusicIxLoadedAndGetIx(int musicIx) {
        if (musicIx < 0) return musicIx;
        auto musicList = GetMusicList();
        if (musicIx >= musicList.Length) {
            dev_warn("Invalid musicIx: " + musicIx);
            return -1;
        }
        auto musicJ = musicList[musicIx];
        string musicName = string(musicJ[0]);
        for (uint i = 0; i < G_MusicDescs.Length; i++) {
            if (G_MusicDescs[i][0] == musicName) {
                return i;
            }
        }
        dev_warn("Music not found in G_MusicDescs: " + musicName);
        G_MusicDescs.InsertLast(musicJ);
        MusicAll.InsertLast(GetAudio().CreateMusic(MEDIA_SOUNDS_TURBO + musicName));
        return G_MusicDescs.Length - 1;
    }


    void UpdateLPF(InGameRaceStateMonitor@ raceState) {
        float TargetLPFratioFromSpeed = Turbo::LPF_CUTOFF_RATIO_MIN;
        float MinValue = Turbo::LPF_CUTOFF_RATIO_MIN;

        if (raceState.CarSpeed < raceState.m_cutoffSpeedThreshold) {
            float MinSpeed = 75.;
            float Speed = Math::Max(raceState.CarSpeed - MinSpeed, 0.0);
            float SpeedComp = raceState.m_cutoffSpeedThreshold - MinSpeed;

            TargetLPFratioFromSpeed = MinValue + (1.-MinValue) * (Speed / SpeedComp);
            if (raceState.m_isQuick) {
                // We lower the intensity of the loop
                CurMusic.EnableSegment("loop");
                CurMusic.NextVariant2(true); //rajouter le randommode après
                raceState.m_isQuick = false;
            }
        } else {
            raceState.m_isQuick = true;
            TargetLPFratioFromSpeed = 1.0;
        }

        bool isPaused = TM_State::InPg_InGameMenuDisplayed || raceState.m_isLastFinished;
        if (raceState.m_isPaused != isPaused) {
            raceState.m_isPaused = isPaused;
            if (isPaused) {
                // Audio.LimitMusicVolumedB = -3.;
            } else {
                // Audio.LimitMusicVolumedB = 0.;
                // SetSFXSceneLevel();
            }
        }

        G_Debug_LastTargetLPFratioFromSpeed = TargetLPFratioFromSpeed;
        if (!raceState.m_isPaused) {
            // trace("LPF: " + CurMusic.LPF_CutoffRatio + " -> " + TargetLPFratioFromSpeed);
            CurMusic.LPF_CutoffRatio = TargetLPFratioFromSpeed;
        } else {
            if (raceState.m_isLastFinished) {
                float max = TargetLPFratioFromSpeed;
                float duration = CurMusic.BeatDuration * 5.;
                float time = 1. * (TM_State::InPg_GameTime - raceState.m_raceStateTrigger_Finished) / 1000.;
                SetMusicLevel();
                G_Debug_LastTargetLPFratioFromSpeed = easeOutCircle(time, max, -max + Turbo::LPF_CUTOFF_RATIO_MIN, duration);
                CurMusic.LPF_CutoffRatio = G_Debug_LastTargetLPFratioFromSpeed;
                // trace("Finish fade out: LPF: " + CurMusic.LPF_CutoffRatio + " -> " + G_Debug_LastTargetLPFratioFromSpeed + " ( " + time + " / " + duration + "; m_raceStateTrigger_Finished: " + m_raceStateTrigger_Finished + "; GameTime: " + GameTime + ")");
            } else {
                CurMusic.LPF_CutoffRatio = G_Debug_LastTargetLPFratioFromSpeed = Turbo::LPF_CUTOFF_RATIO_MIN + 0.1;
            }
        }
    }

    void InitRandomMusicIndicies() {
        auto mList = GetMusicList();
        auto musicCount = Math::Min(mList.Length, 6);
        auto maxMusicCount = mList.Length;
        G_MusicRandomIndice.Resize(maxMusicCount);
        for (uint i = 0; i < maxMusicCount; i++) {
            G_MusicRandomIndice[i] = i;
        }
        for (uint i = 0; i < maxMusicCount; i++) {
            auto j = Math::Rand(i, maxMusicCount - 1);
            auto tmp = G_MusicRandomIndice[i];
            G_MusicRandomIndice[i] = G_MusicRandomIndice[j];
            G_MusicRandomIndice[j] = tmp;
        }
        G_MusicDescs.Reserve(musicCount);
        for (uint i = 0; i < musicCount; i++) {
            G_MusicDescs.InsertLast(mList[G_MusicRandomIndice[i]]);
        }
    }

    int G_LastMusicToPlayIx = -1;

    void LoadMusic(int musicIx) {
        ResetSounds(true);
        if (MusicAll.Length < G_MusicDescs.Length) {
            MusicAll.Resize(G_MusicDescs.Length);
        }
        auto musicToPlay = musicIx;
        if (musicIx == -1) {
            musicToPlay = Math::Rand(0, MusicAll.Length - 1);
            // on relance une fois on a la même / we restart once we have the same
            if (G_PrevPlayedTrack == musicToPlay) {
                musicToPlay = Math::Rand(0, MusicAll.Length - 1);
            }
            G_PrevPlayedTrack = musicToPlay;
        }
        if (musicIx < -1) {
            musicToPlay = MusicAll.Length + musicIx + 1;
        }

        G_LastMusicToPlayIx = musicToPlay;

        if (MusicAll[musicToPlay] !is null) {
            G_Debug_SongName = G_MusicDescs[musicToPlay][0];
            print("Loading music: " + G_Debug_SongName);
            @CurMusic = MusicAll[musicToPlay]; // (la musique précédente qu'on ecrase est stoppée par ResetSounds() juste avant) / (the previous music we overwrite is stopped by ResetSounds() just before)
            CurMusic.VolumedB = -10.;
            CurMusic.FadeDuration = 0.35;
            CurMusic.FadeTracksDuration = CurMusic.BeatDuration * 2;
            CurMusic.Play();
            CurMusic.EnableSegment("loop");
            CurMusic.NextVariant2(true);

            G_MusicGain = G_MusicDescs[musicToPlay][1];
            G_MusicDelay = 0;

            SetMusicLevel();

            // int musicRandInd = 0;
            // if (G_MusicRandomIndice.Length > musicToPlay) {
            //     musicRandInd = G_MusicRandomIndice[musicToPlay];
            // } else {
            //     warn("musique petee / broken music");
            // }
        } else {
            warn("CANT LOAD MUSIC IX AT: " + musicToPlay);
        }
    }

    void PreloadMusic() {
        if (MusicAll.Length != 0) {
            throw("MusicAll is not empty");
        }

        auto audio = cast<CTrackMania>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.Audio;
        for (uint i = 0; i < G_MusicDescs.Length; i++) {
            auto @j = G_MusicDescs[i];
            auto audioPath = MEDIA_SOUNDS_TURBO + string(j[0]);
            trace("Loading music: " + audioPath);
            MusicAll.InsertLast(
                audio.CreateMusic(audioPath)
            );
            if (MusicAll[i] is null) {
                warn("MusicAll[" + i + "] is null; file: " + audioPath);
            }
        }

        if (MusicStandby is null) {
            auto file = MEDIA_SOUNDS_TURBO + TurboConst::GetMusicStandBy();
            @MusicStandby = audio.CreateSoundEx(file, Turbo::VolumedB_MusicStandBy, true, true, false);
            if (MusicStandby is null) {
                warn("MusicStandby is null; file: " + file);
            }
            // if ({{{_IsTrackbuilder}}}) yield;
            MusicStandby.Stop();
            MusicStandby.VolumedB = Turbo::VolumedB_MusicStandBy;
            MusicStandby.PanRadiusLfe = Turbo::GetMusicPanRadiusLfe(Turbo::VolumeCase::MusicStandby);
            // todo: standby event
            // @G_SoundStandbyEvent = audio.CreateSoundEx(MEDIA_SOUNDS_TURBO + TurboConst::SoundGameStart, GetVolumedB("MusicStandBy"), true, false, false);
            // G_SoundStandbyEvent.PanRadiusLfe = MusicStandby.PanRadiusLfe;
        }

        if (MusicReplay is null) {
            @MusicReplay = audio.CreateSoundEx(MEDIA_SOUNDS_TURBO + TurboConst::MusicReplay, Turbo::VolumedB_MusicReplay, true, true, false);
            // if ({{{_IsTrackbuilder}}}) yield;
            MusicReplay.Stop();
            MusicReplay.VolumedB = Turbo::VolumedB_MusicReplay;
            MusicReplay.PanRadiusLfe = Turbo::GetMusicPanRadiusLfe(Turbo::VolumeCase::MusicReplay);
        }
    }

    void PreloadAllMusicAndSounds() {
        PreloadMusic();
        LoadMusic(-1);
    }

    void OnStartRace_Reset() {
        CurMusic.LPF_CutoffRatio = Turbo::LPF_CUTOFF_RATIO_MIN;
        CurMusic.UpdateMode = TurboMusicUpdateMode;
        CurMusic.Dbg_ForceSequential = false;
        CurMusic.Dbg_ForceIntensity = false;
        CurMusic.Dbg_ForceRandom = false;
        CurMusic.EnableSegment("lap");
        SetMusicLevel();
        CurMusic.Play();
        CurMusic.NextVariant2(true);
        trace("CurMusic.Play() " + CurMusic.IdName);
#if DEV
        // ExploreNod(CurMusic);
#endif
    }

    void SetMusicLevel() {
        CurMusic.VolumedB = G_MusicGain;
        CurMusic.PanRadiusLfe = Turbo::GetMusicPanRadiusLfe(Turbo::VolumeCase::MusicIngame);
    }

    void ResetSounds(bool _ResetStandby) {
        if (_ResetStandby) MusicStandby.Stop();
        if (_ResetStandby) MusicReplay.Stop();
        if (CurMusic !is null) {
            CurMusic.Stop();
            CurMusic.VolumedB = -100.;
        }
    }

    void RenderMenuTools() override {
        UI::BeginDisabled();
        UI::MenuItem("Track: " + G_Debug_SongName);
        UI::EndDisabled();
        if (UX::SmallButton("Next Track")) {
            LoadMusic(-1);
        }
    }

    int GetCurrTrackIx() override {
        return G_LastMusicToPlayIx;
    }

    string GetCurrTrackName() override {
        return G_Debug_SongName;
    }

    string GetTimeProgressString() override {
        return "-:--";
    }
}

namespace Turbo {
    const float VolumedB_MusicReplay = -5.0;
    const float VolumedB_MusicStandBy = 0.0;
    const float VolumedB_MusicBoosted = 4.6;
}





// Selects music randomly (or by filter) from a list of tracks.
// e.g., turbo menu, mp4 all, tm2020 all
class Music_StdTrackSelection : MusicOrSound {
    string[]@ MusicPaths;
    string[] MusicShortPaths;
    CAudioScriptSound@[] MusicAll;
    int curTrackIx = -1;
    bool _init;
    // passed to CreateSoundEx
    bool isMusic, isLooping;
    string baseDir;

    Music_StdTrackSelection(const string &in name, const string &in baseDir, string[]@ musicPaths = null, bool isMusic = true, bool isLooping = true) {
        super(name);
        this.baseDir = baseDir;

        this.isMusic = isMusic;
        this.isLooping = isLooping;

        @MusicPaths = musicPaths;
        if (MusicPaths is null) @MusicPaths = {};
        if (MusicPaths.Length > 0) startnew(CoroutineFunc(Init));
        else dev_warn("MusicPaths is empty");
    }

    Music_StdTrackSelection@ WithOriginPack(AudioPack@ origin) {
        @this.origin = origin;
        return this;
    }

    void RenderDebug() override {
        UI::Text("Song: " + (curTrackIx+1) + " - " + debug_CurrMusicPath + " ["+Time::Format(int64(debug_CurrMusicLength * 1000.), false, true, false, true)+"]");
        UI::Text("Total Songs: " + MusicPaths.Length);
        if (UX::SmallButton("Next Track")) {
            startnew(CoroutineFunc(On_NextTrack));
        }
        RenderSongChoiceMenu();
    }

    void RenderSongChoiceMenu() {
        if (origin is null) {
            UI::Text("\\$i\\$999" + name + ": Origin pack is null");
            return;
        }
        origin.RenderSongChoiceMenu();
        // if (UI::BeginMenu(name)) {
        //     for (uint i = 0; i < MusicShortPaths.Length; i++) {
        //         if (UI::MenuItem(MusicShortPaths[i], "", curTrackIx == i)) {
        //             this.SetThisAsCurrentMusicChoice();
        //             if (curTrackIx != i) {
        //                 SelectAndPreloadTrack(i);
        //             }
        //             // SetCustAndActualVolume(0, i);
        //             // startnew(CoroutineFuncUserdata(SelectAndPreloadTrack), i);
        //         }
        //     }
        //     UI::EndMenu();
        // }
    }

    void RenderMenuTools() override {
        UI::BeginDisabled();
        UI::MenuItem("Song: " + (curTrackIx+1) + " - " + debug_CurrMusicPath + "  ["+Time::Format(int64(debug_CurrMusicLength * 1000.), true, true, false, true)+"]");
        UI::EndDisabled();
        if (curTrackIx < 0 || curTrackIx >= MusicAll.Length) {
            warn("Invalid curTrackIx: " + curTrackIx);
            return;
        }

        auto music = MusicAll[curTrackIx];
        if (music !is null) {
            auto source = cast<CAudioSource>(Dev::GetOffsetNod(music, 0x20));
            // UI::PushItemWidth(200.);
            float origCursorUi = source.PlayCursorUi;
            float newCursorUi = UI::SliderFloat("Play Cursor", origCursorUi, 0., 1., Time::Format(int64(source.PlayCursor * 1000.)));
            if (newCursorUi != origCursorUi) {
                source.PlayCursorUi = newCursorUi;
            }
            source.VolumedB = UI::SliderFloat("Track vol dB", source.VolumedB, -41., 12.);
            if (source.PlugSound !is null) {
                source.PlugSound.VolumedB = UI::SliderFloat("Sound vol dB", source.PlugSound.VolumedB, -41., 12.);
            }

            // UI::PopItemWidth();
        }

        UI::Dummy(vec2(0., 2.), 0.);
        if (UX::SmallButton("Next Track")) {
            startnew(CoroutineFunc(On_NextTrack));
        }
        UI::Dummy(vec2(0., 2.), 0.);
    }

    void SetThisAsCurrentMusicChoice() {
        Music::SetCurrentMusicChoice(this.origin);
    }

    void CleanUp() override {
        auto audio = GetAudio();
        CleanupSounds(audio, MusicAll);
    }

    void OnContextEnter() override {
        On_NextTrack();
        // we can technically double up on these loops, but they resolve cleanly anyway. better than no loops running.
        startnew(CoroutineFuncUserdataInt64(this.WatchForEndMusicTrack), int64(curTrackIx));
    }

    void OnContextLeave() override {
        // I think we can do nothing here and music auto-pauses and resumes.
        // ResetActiveTrack();
    }

    void Init() {
        if (_init) return;
        _init = true;
        for (uint i = 0; i < MusicPaths.Length; i++) {
            MusicShortPaths.InsertLast(MusicPaths[i].SubStr(baseDir.Length));
        }
        SelectAndPreloadTrack();
        dev_warn("Music_StdTrackSelection initialized; MusicAll.Length: " + MusicAll.Length);
    }

    // user presses button or w/e
    void On_NextTrack() {
        SelectAndPreloadTrack(S_Playlist_Sequential ? curTrackIx + 1 : -1);
    }

    void SelectAndPreloadTrack(int trackIx = -1) {
        ResetActiveTrack();
        ChooseNewCurrentTrack(trackIx);
        PreloadSelectedTrack();
    }

    void ResetActiveTrack() {
        if (curTrackIx >= 0 && curTrackIx < MusicAll.Length) {
            if (MusicAll[curTrackIx] !is null && MusicAll[curTrackIx].IsPlaying) {
                MusicAll[curTrackIx].Stop();
                MusicAll[curTrackIx].VolumedB = -100.0;
                CleanupSound(GetAudio(), MusicAll[curTrackIx]);
                @MusicAll[curTrackIx] = null;
            }
        }
    }

    string debug_CurrMusicPath;
    float debug_CurrMusicLength;

    void ChooseNewCurrentTrack(int trackIx = -1) {
        // if (_chooseRandomly)
        curTrackIx = trackIx < 0 ? Math::Rand(0, MusicPaths.Length) : trackIx % MusicPaths.Length;
        debug_CurrMusicPath = MusicShortPaths[curTrackIx];
    }

    void PreloadSelectedTrack() {
        dev_warn("Preloading music: " + MusicPaths[curTrackIx]);
        auto audio = GetAudio();
        MusicAll.Resize(MusicPaths.Length);
        auto music = @MusicAll[curTrackIx];
        if (music is null) {
            @music = audio.CreateSoundEx(MusicPaths[curTrackIx], 0.0, true, true, false);
            @MusicAll[curTrackIx] = music;
            debug_CurrMusicLength = music.PlayLength;
            startnew(CoroutineFuncUserdataInt64(this.WatchForEndMusicTrack), int64(curTrackIx));
        }
        // see Turbo::GetMusicPanRadiusLfe for other settings
        auto panRadiusLfe = vec3(0., 1.,   -20.);
        tmpVoldB = GetMusicVolume(MusicPaths[curTrackIx]);
        music.PanRadiusLfe = panRadiusLfe;
        music.VolumedB = 0.0;
        auto source = cast<CAudioSource>(Dev::GetOffsetNod(music, 0x20));
        source.PlugSound.VolumedB = tmpVoldB;
        music.Play();
        // auto ptr = Dev_GetPtrForNod(music);
        // dev_trace("Preloaded music: " + MusicPaths[curTrackIx] + " (ptr: " + Text::FormatPointer(ptr) + ")");
        // IO::SetClipboard(Text::FormatPointer(ptr));
        this.FixMusicViaBalanceGroups(music);
        // startnew(CoroutineFuncUserdata(this.FixMusicViaBalanceGroups), music);
    }

    // watch for end of track and play next
    void WatchForEndMusicTrack(int64 _curTrackIx) {
        int initCurrIx = _curTrackIx;
        bool wasCursorNearlyDone = false;
        auto tmCtxFlags = TM_State::ContextFlags;
        while (TM_State::ContextIsNoneOrMatch(tmCtxFlags) && curTrackIx == initCurrIx && MusicAll.Length > curTrackIx && MusicAll[curTrackIx] !is null) {
            auto @music = MusicAll[curTrackIx];
            auto source = cast<CAudioSource>(Dev::GetOffsetNod(music, 0x20));
            if (source.PlayCursorUi > 0.95) {
                wasCursorNearlyDone = true;
            } else if (wasCursorNearlyDone && source.PlayCursorUi < 0.05) {
                dev_warn("Music track ended: " + MusicShortPaths[curTrackIx]);
                // go next
                if (!S_Playlist_RepeatOne) {
                    On_NextTrack();
                    break;
                } else {
                    wasCursorNearlyDone = false;
                }
            } else {
                wasCursorNearlyDone = false;
            }
            yield();
        }
        dev_trace("WatchForEndMusicTrack ended; musicAll.Length: " + MusicAll.Length + "; curTrackIx: " + curTrackIx);
    }

    float tmpVoldB = 0.0;

    void FixMusicViaBalanceGroups(ref@ r) {
        CAudioScriptSound@ music = cast<CAudioScriptSound>(r);
        // yield(1);
        dev_trace("Fixing music balance group: " + MusicPaths[curTrackIx]);
        auto audioSource = cast<CAudioSource>(Dev::GetOffsetNod(music, 0x20));
        if (audioSource.PlayCursorUi > 0.0) {
            dev_trace("Skipping balance group fix for music: " + MusicPaths[curTrackIx] + " (PlayCursorUi: " + audioSource.PlayCursorUi + ")");
            return;
        }
        if (audioSource !is null) {
            dev_warn("Setting balance group for audio source: " + MusicPaths[curTrackIx]);
            audioSource.BalanceGroup = CAudioSource::EAudioBalanceGroup::Custom1;
            audioSource.VolumedB = 0.0;
            audioSource.Play();
            // yield(1);
            // audioSource.BalanceGroup = CAudioSource::EAudioBalanceGroup::Music;
            // audioSource.VolumedB = 0.0;
            // audioSource.Play();
            dev_warn("Set balance group for audio source: " + MusicPaths[curTrackIx]);
        } else {
            dev_warn("Audio source is null for music: " + MusicPaths[curTrackIx]);
        }
    }

    dictionary customVolume;

    float GetMusicVolume(const string &in path) {
        if (customVolume.Exists(path)) {
            return float(customVolume[path]);
        }
        return 0.;
    }

    void SetCustomVolume(float vol, const string &in musicPath) {
        customVolume[musicPath] = vol;
    }

    void SetCustAndActualVolume(float vol, uint trackIx) {
        customVolume[MusicPaths[trackIx]] = vol;
        if (MusicAll[trackIx] !is null) {
            MusicAll[trackIx].VolumedB = vol;
        }
    }

    CAudioScriptSound@ GetCurrMusic() {
        if (curTrackIx < 0 || curTrackIx >= MusicAll.Length) {
            warn("Invalid curTrackIx: " + curTrackIx);
            return null;
        }
        return MusicAll[curTrackIx];
    }

    int GetCurrTrackIx() override {
        return curTrackIx;
    }

    string GetCurrTrackName() override {
        if (curTrackIx < 0 || curTrackIx >= MusicShortPaths.Length) {
            return "No track";
        }
        return MusicShortPaths[curTrackIx];
    }

    string GetTimeProgressString() override {
        auto music = GetCurrMusic();
        if (music is null) {
            return "-:-- / -:--";
        }
        auto totalLen = Time::Format(int64(music.PlayLength * 1000.), false, true, false, true);
        auto playLen = Time::Format(int64(music.PlayCursor * 1000.), false, true, false, true);
        return playLen + " / " + totalLen;
    }
}

class Music_TurboInMenu : Music_StdTrackSelection {
    Music_TurboInMenu() {
        super("Turbo Menu Music", "file://", {
            MEDIA_SOUNDS_TURBO + TurboConst::MusicMenuSimple,
            MEDIA_SOUNDS_TURBO + TurboConst::MusicMenuSimple2
        });
        SetCustomVolume(6, MusicPaths[1]);
    }
}

// Sound Effects for e.g., end race, checkpoints, etc
class GameSounds : MusicOrSound {
    CAudioScriptSound@[] StartLine;
    CAudioScriptSound@[] FinishLine;
    CAudioScriptSound@[] FinishLap;
    CAudioScriptSound@[] CheckpointsFaster;
    CAudioScriptSound@[] CheckpointsSlower;
    CAudioScriptSound@[] Respawn;
    CAudioScriptSound@ SoundStandbyEvent;
    GameSoundsSpec@ Spec;
    string baseDir;

    GameSounds(const string &in name, const string &in baseDir, GameSoundsSpec@ spec = null) {
        super(name);
        @Spec = spec;
        this.baseDir = baseDir;
        if (spec !is null) {
            PreloadSpecSounds();
        }
    }

    GameSounds@ WithOriginPack(AudioPack@ origin) {
        @this.origin = origin;
        return this;
    }

    void PreloadSpecSounds() {
        dev_warn("Preloading sounds for " + name + " @ " + baseDir);
        auto audio = GetAudio();
        LoadFilesToScriptSounds(audio, baseDir, Spec.startRace, StartLine);
        LoadFilesToScriptSounds(audio, baseDir, Spec.finishRace, FinishLine);
        LoadFilesToScriptSounds(audio, baseDir, Spec.finishLap, FinishLap);
        LoadFilesToScriptSounds(audio, baseDir, Spec.checkpointFast, CheckpointsFaster);
        LoadFilesToScriptSounds(audio, baseDir, Spec.checkpointSlow, CheckpointsSlower);
        LoadFilesToScriptSounds(audio, baseDir, Spec.respawn, Respawn);
    }

    void CleanUp() override {
        auto audio = GetAudio();
        CleanupSounds(audio, FinishLine);
        CleanupSounds(audio, FinishLap);
        CleanupSounds(audio, StartLine);
        CleanupSounds(audio, Respawn);
        CleanupSounds(audio, CheckpointsFaster);
        CleanupSounds(audio, CheckpointsSlower);
        CleanupSound(audio, SoundStandbyEvent);
        @SoundStandbyEvent = null;

    }

    // finish ui sequence lags by 1 frame, so we delay CP sounds by 1 frame too :/
    int queueCpNextFrame = -1;
    bool queueCpNextFrame_Fast = false;

    void UpdateRace(InGameRaceStateMonitor@ raceState) override {
        // check queued cp sounds first to avoid clobbering
        if (queueCpNextFrame >= 0) {
            if (raceState.didFinishThisFrame || raceState.m_isLastFinished) {
                // do nothing, we caught it
            } else {
                OnCheckpoint(queueCpNextFrame, queueCpNextFrame_Fast);
            }
            queueCpNextFrame = -1;
        }


        if (raceState.didFinishThisFrame) OnFinish();
        else if (raceState.startedThisFrame) OnStart();
        else if (raceState.cpTakenThisFrame >= 0 && !raceState.playerRespawned && !raceState.m_isLastFinished) {
            queueCpNextFrame = raceState.cpTakenThisFrame;
            queueCpNextFrame_Fast = raceState.cpThisFrameWasFast;
            // OnCheckpoint(raceState.cpTakenThisFrame, raceState.cpThisFrameWasFast);
        }
    }

    void OnStart() override {
        if (Spec.startRace.Length == 0) return;
        auto sound = GetAudio().CreateSound(baseDir + ChooseRandom(Spec.startRace));
        sound.VolumedB = 0.;
        sound.Play();
        startnew(SleepAndDestroy, sound);
    }

    void OnFinish() override {
        if (Spec.finishRace.Length == 0) return;
        auto sound = GetAudio().CreateSound(baseDir + ChooseRandom(Spec.finishRace));
        sound.VolumedB = 0.;
        sound.Play();
        startnew(SleepAndDestroy, sound);
    }

    void OnCheckpoint(int cpCount, bool fast) override {
        auto @s_cps = Spec.GetCheckpoints(fast);
        if (s_cps.Length == 0) return;
        cpCount = Math::Clamp(cpCount, 0, s_cps.Length - 1);
        auto sound = GetAudio().CreateSound(baseDir + s_cps[cpCount]);
        // auto sound = GetAudio().CreateSound(MEDIA_SOUNDS_TURBO + (fast ? TurboConst::GetSoundCheckpointFast(cpCount) : TurboConst::GetSoundCheckpointSlow(cpCount)));
        sound.VolumedB = 0.;
        sound.Play();
        startnew(SleepAndDestroy, sound);
    }

    void OnLap(int lapCount) override {
        if (Spec.finishLap.Length == 0) return;
        auto sound = GetAudio().CreateSound(baseDir + ChooseRandom(Spec.finishLap));
        sound.VolumedB = 0.;
        sound.Play();
        startnew(SleepAndDestroy, sound);
    }

    int GetCurrTrackIx() override {
        return 0;
    }

    string GetCurrTrackName() override {
        return name;
    }

    string GetTimeProgressString() override {
        return "-:--";
    }
}

string ChooseRandom(string[]@ arr) {
    if (arr.Length == 0) throw("ChooseRandom: empty array");
    return arr[Math::Rand(0, arr.Length)];
}

void LoadFilesToScriptSounds(CAudioScriptManager@ audio, const string &in baseDir, string[]@ files, CAudioScriptSound@[]@ sounds) {
    if (files is null) return;
    sounds.Reserve(files.Length);
    for (uint i = 0; i < files.Length; i++) {
        sounds.InsertLast(audio.CreateSound(baseDir + files[i]));
    }
}

class GameSounds_Turbo : GameSounds {
    GameSounds_Turbo() {
        throw("deprecate me");
        super("Turbo GameSounds", "file://",  GameSoundsSpec());
        startnew(CoroutineFunc(PreloadSounds)); // .WithRunContext(Meta::RunContext::GameLoop);
        dev_trace("GameSounds_Turbo created");
    }

    void PreloadSounds() {
        auto audio = GetAudio();
        FinishLine.InsertLast(audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundFinishLine));
        StartLine.InsertLast(audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundStartLine));
        StartLine.InsertLast(audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundStartLine2));
        @SoundStandbyEvent = audio.CreateSoundEx(MEDIA_SOUNDS_TURBO + TurboConst::SoundGameStart, 0.0, true, false, false);
        if (CheckpointsFaster.Length > 0 || CheckpointsSlower.Length > 0) {
            throw('Checkpoints already preloaded; faster: ' + CheckpointsFaster.Length + ', slower: ' + CheckpointsSlower.Length);
        }
        CheckpointsFaster.Reserve(8);
        CheckpointsSlower.Reserve(8);
        for (uint i = 1; i <= 8; i++) {
            CheckpointsFaster.InsertLast(audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundCheckpointFast + i + ".ogg"));
            CheckpointsSlower.InsertLast(audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundCheckpointSlow + i + ".ogg"));
        }
    }

    void OnStart() override {
        return;
        // this doesn't play in TMT, and doesn't sound very good either xd
        // auto sound = GetAudio().CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::GetSoundStartLine());
        // sound.VolumedB = 0.;
        // sound.Play();
        // startnew(SleepAndDestroy, sound);
    }

    void OnFinish() override {
        auto sound = GetAudio().CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundFinishLine);
        sound.VolumedB = 0.;
        sound.Play();
        startnew(SleepAndDestroy, sound);
    }

    void OnCheckpoint(int cpCount, bool fast) override {
        auto sound = GetAudio().CreateSound(MEDIA_SOUNDS_TURBO + (fast ? TurboConst::GetSoundCheckpointFast(cpCount) : TurboConst::GetSoundCheckpointSlow(cpCount)));
        sound.VolumedB = 0.;
        sound.Play();
        startnew(SleepAndDestroy, sound);
    }
}


// MARK: - Helpers


void SleepAndDestroy(ref@ _sound) {
    auto sound = cast<CAudioScriptSound>(_sound);
    sleep(int(sound.PlayLength * 1000));
    trace('removing sound with length: ' + sound.PlayLength);
    sound.Stop();
    GetAudio().DestroySound(sound);
}

CAudioScriptManager@ GetAudio() {
    return cast<CTrackMania>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.Audio;
}

void CleanupMusic(CAudioScriptManager@ audio, CAudioScriptMusic@ music) {
    if (music !is null) {
        music.Stop();
        audio.DestroyMusic(music);
    }
}

// also empties the array
void CleanupMusics(CAudioScriptManager@ audio, CAudioScriptMusic@[]@ musics) {
    for (uint i = 0; i < musics.Length; i++) {
        CleanupMusic(audio, musics[i]);
        @musics[i] = null;
    }
    musics.RemoveRange(0, musics.Length);
}

void CleanupSound(CAudioScriptManager@ audio, CAudioScriptSound@ sound) {
    if (sound !is null) {
        sound.Stop();
        audio.DestroySound(sound);
    }
}

// also empties the array
void CleanupSounds(CAudioScriptManager@ audio, CAudioScriptSound@[]@ sounds) {
    for (uint i = 0; i < sounds.Length; i++) {
        CleanupSound(audio, sounds[i]);
        @sounds[i] = null;
    }
    sounds.RemoveRange(0, sounds.Length);
}

// t: current time, b: beginning value, c: change in value, d: duration
float easeOutCircle(float t, float b, float c, float d) {
    if (t >= 1.0) return c + b;
    if (t <= 0.0) return b;
    t = t / d - 1.0;
    // trace('t: ' + t + ' b: ' + b + ' c: ' + c + ' d: ' + d);
    return c * Math::Sqrt(1. - t*t) + b;
}
