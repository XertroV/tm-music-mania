// Music scopes: menu, editor, game


class MusicOrSound {
    string name;
    MusicOrSound(const string &in name) {
        this.name = name;
        dev_trace("MusicOrSound Created: " + name);
    }
    ~MusicOrSound() {
        CleanUp();
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

    Music_TurboInGame() {
        super("Turbo In-Game Music");
        InitRandomMusicIndicies();
        PreloadAllMusicAndSounds();
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
                    LoadMusic(-1);
                    ResetSounds(true);
                    OnStartRace_Reset();
                    break;
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
        auto musicCount = Math::Min(TurboMusicList.Length, 6);
        auto maxMusicCount = TurboMusicList.Length;
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
            G_MusicDescs.InsertLast(TurboMusicList[G_MusicRandomIndice[i]]);
        }
    }



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

        if (MusicAll[musicToPlay] !is null) {
            G_Debug_SongName = G_MusicDescs[musicToPlay][0];
            print("Loading music: " + G_Debug_SongName);
            @CurMusic = MusicAll[musicToPlay]; // (la musique précédente qu'on ecrase est stoppée par ResetSounds() juste avant) / (the previous music we overwrite is stopped by ResetSounds() just before)
            CurMusic.VolumedB = -100.;
            CurMusic.FadeDuration = 0.35;
            CurMusic.FadeTracksDuration = CurMusic.BeatDuration * 2;
            CurMusic.Play();

            G_MusicGain = G_MusicDescs[musicToPlay][1];
            G_MusicDelay = 0;

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
    CAudioScriptSound@[] MusicAll;
    int curTrackIx = -1;
    bool _init;
    // passed to CreateSoundEx
    bool isMusic, isLooping;

    Music_StdTrackSelection(const string &in name, string[]@ musicPaths = null, bool isMusic = true, bool isLooping = true) {
        super(name);

        this.isMusic = isMusic;
        this.isLooping = isLooping;

        @MusicPaths = musicPaths;
        if (MusicPaths is null) @MusicPaths = {};
        if (MusicPaths.Length > 0) Init();
    }

    void CleanUp() override {
        auto audio = GetAudio();
        CleanupSounds(audio, MusicAll);
    }

    void OnContextEnter() override {
        On_NextTrack();
    }

    void OnContextLeave() override {
        // I think we can do nothing here and music auto-pauses and resumes.
        // ResetActiveTrack();
    }

    void Init() {
        if (_init) return;
        _init = true;
        SelectAndPreloadTrack();
    }

    // user presses button or w/e
    void On_NextTrack() {
        SelectAndPreloadTrack();
    }

    void SelectAndPreloadTrack() {
        ResetActiveTrack();
        ChooseNewCurrentTrack();
        PreloadSelectedTrack();
    }

    void ResetActiveTrack() {
        if (curTrackIx >= 0 && curTrackIx < MusicAll.Length) {
            if (MusicAll[curTrackIx] !is null && MusicAll[curTrackIx].IsPlaying) {
                MusicAll[curTrackIx].Stop();
            }
        }
    }

    void ChooseNewCurrentTrack() {
        // if (_chooseRandomly)
        curTrackIx = Math::Rand(0, MusicPaths.Length);
    }

    void PreloadSelectedTrack() {
        auto audio = GetAudio();
        MusicAll.Resize(MusicPaths.Length);
        if (MusicAll[curTrackIx] is null) {
            @MusicAll[curTrackIx] = audio.CreateSoundEx(MusicPaths[curTrackIx], 0.0, true, true, false);
        }
        auto music = @MusicAll[curTrackIx];
        // see Turbo::GetMusicPanRadiusLfe for other settings
        music.PanRadiusLfe = vec3(0., 1.,   -20.);
        music.VolumedB = GetMusicVolume(MusicPaths[curTrackIx]);
        music.Play();
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

}

class Music_TurboInMenu : Music_StdTrackSelection {
    Music_TurboInMenu() {
        super("Turbo Menu Music", {
            MEDIA_SOUNDS_TURBO + TurboConst::MusicMenuSimple,
            MEDIA_SOUNDS_TURBO + TurboConst::MusicMenuSimple2
        });
        SetCustomVolume(6, MusicPaths[1]);
    }
}

// Sound Effects for e.g., end race, checkpoints, etc
class GameSounds : MusicOrSound {
    GameSounds(const string &in name) {
        super(name);
    }
}

class GameSounds_Turbo : GameSounds {
    CAudioScriptSound@ FinishLine;
    CAudioScriptSound@ StartLine;
    CAudioScriptSound@ StartLine2;
    CAudioScriptSound@[] CheckpointsFaster;
    CAudioScriptSound@[] CheckpointsSlower;
    CAudioScriptSound@ SoundStandbyEvent;

    GameSounds_Turbo() {
        super("Turbo GameSounds");
        startnew(CoroutineFunc(PreloadSounds)); // .WithRunContext(Meta::RunContext::GameLoop);
        dev_trace("GameSounds_Turbo created");
    }

    void PreloadSounds() {
        auto audio = GetAudio();
        @FinishLine = audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundFinishLine);
        @StartLine = audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundStartLine);
        @StartLine2 = audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundStartLine2);
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

    void CleanUp() override {
        auto audio = GetAudio();
        CleanupSound(audio, FinishLine);
        CleanupSound(audio, StartLine);
        CleanupSound(audio, StartLine2);
        CleanupSound(audio, SoundStandbyEvent);
        @FinishLine = null;
        @StartLine = null;
        @StartLine2 = null;
        @SoundStandbyEvent = null;
        CleanupSounds(audio, CheckpointsFaster);
        CleanupSounds(audio, CheckpointsSlower);
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

    void UpdateRace(InGameRaceStateMonitor@ raceState) override {
        if (raceState.didFinishThisFrame) OnFinish();
        else if (raceState.startedThisFrame) OnStart();
        else if (raceState.cpTakenThisFrame >= 0) {
            OnCheckpoint(raceState.cpTakenThisFrame, raceState.cpThisFrameWasFast);
        }
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
