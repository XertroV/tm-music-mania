// TurboMusic@ ReadTurboMusicFromDirectory(const string &in path) {
//     return TurboMusic(path);
// }

Json::Value@ GetTurboMusicListJson() {
    // [[main file, gain, name, label, author, sample]]
    // note: we don't care about sample
    return Json::Parse('[["120 Breakbot ShadesOfBlack.zip", 1.5, "Shades of Black", "Ed Banger", "Breakbot", "Breakbot-Shades of black.ogg"], ["136 Cavart ClubSuede.zip", -0.5, "Club Suede", "Romain Cavart", "Cavart", "Cavart_ClubSuede.ogg"], ["124 4getMeNot ABroad.zip", 1.0, "AB ROAD", "Jarring Effects", "4GetMeNot", "4GetMeNot_ABroad.ogg"], ["87 Bustre Combine.zip", -0.5, "Combine", "Monstercat", "Bustre", "Bustre_Combine.ogg"], ["128 Bleaker Untitled.zip", 2.5, "Untitled", "Bleaker", "Bleaker", "Bleaker-Untitled.ogg"], ["126,4 DJPC GoToTheMoon.zip", 2.0, "Go To The Moon", "Now Discs", "DJPC", "DraftDodger_M-57.ogg"], ["126 Aethority DirtyJose.zip", 5.0, "Dirty Jose", "Living Large Publishing / Schubert Music Publishing", "Aethority", "Aethority_DirtyJose.ogg"], ["119 Costello Primal.zip", -2.0, "Primal", "Boysnoize Records", "Costello", "Costello_-_Primal.ogg"], ["130 Photonz Xabregas.zip", 1.5, "Xabregas", "One Eyed Jacks", "Photonz", "Photonz - Xabregas.ogg"], ["126 Don Rimini AdamandEve.zip", 1.5, "Adam & Eve (Dub)", "Brooklyn Fire Records", "Don Rimini", "DonRimini_AdamAndEve.ogg"], ["122 Mitch MurderBreeze.zip", 0.5, "Breeze", "Mad Decent", "Mitch Murder", "Mitch Murder - Breeze.ogg"], ["130 TWR72 Stefan.zip", 0.5, "Stefan", "Turbo Recordings", "TWR72", "TWR72_-_Stefan.ogg"], ["130 Granit Cris.zip", 0.0, "Cris", "JFX LAB", "GraniT", "Granit_Cris.ogg"], ["132 Photonz Babalon.zip", 2.5, "Babalon", "Photonz", "Photonz", "Photonz_Babalon.ogg"], ["140 DraftDodger 928GTS.zip", 0.0, "928 GTS", "Midnight Trouble", "Draft Dodger", "DraftDodger_928GTS.ogg"], ["130 TWR72 Steie.zip", 1.0, "Steie", "Turbo Recordings", "TWR72", "TWR72_-_Steie.ogg"], ["133.41 Grassilac ShooBeeDoo.zip", 3.0, "Shoo Bee Doo", "Now Discs", "Grassilac", "Grassilac Shoo Bee Doo.ogg"], ["126 Benoit B Traxxmen.zip", 3.0, "TraxxMen", "Beno\\u00eet Bovis", "Benoit B.", "Benoit_B-Traxxmen.ogg"], ["130 StripSteve Metadata.zip", -1.0, "Metadata", "Boysnoize Records", "Strip Steve", "Strip_Steve_-_Metadata.ogg"], ["118 DJ Pone ErroticImpulses.zip", 1.5, "Errotic Impulses", "Ed Banger Records", "Dj Pone ft. Arnaud Rebotini", "DJPone_ErroticImpulses.ogg"], ["125 Randomer NoHook.zip", 1.0, "No Hook", "Turbo Recordings", "Randomer", "Randomer_-_No_Hook.ogg"], ["129 Coni Flip.zip", 0.0, "Flip", "ClekClekBoom", "Coni", "Coni_Flip.ogg"], ["126 Qoso Jura.zip", 0.0, "Jura", "In Paradisum", "Qoso", "Qoso_Jura.ogg"], ["120 MitchMurder Breakazoid.zip", 0.5, "Breakazoid", "Mad Decent", "Mitch Murder", "Mitch Murder - Breakazoid.ogg"], ["126 Rushmore Sensation.zip", 1.5, "Sensation", "Rushmore", "Rushmore", "Rushmore-Sensation.ogg"], ["104 BusyP RainbowMan.zip", 3.0, "Rainbow Man", "Ed Banger", "Busy P", "BusyP_RainbowMan.ogg"], ["140 DeonCustom  Roses.zip", -1.0, "Roses", "Monstercat", "Deon Custom", "DeonCustom_Roses.ogg"], ["135 DraftDodger Choon.zip", 1.5, "Choon", "Draft Dodger", "Draft Dodger", "DraftDodger-Choon.ogg"], ["128 Photonz Errortrak.zip", -2.0, "Errortrak", "Photonz", "Photonz", "Photonz-Errortrak.ogg"], ["87 Droptek Colossus.zip", -2.0, "Colossus", "Monstercat", "Droptek", "Droptek_Colossus.ogg"], ["126 GingyandBordello BodyAcid.zip", 1.5, "Body Acid", "Turbo Recordings", "Gingy & Bordello", "Gingy&Bordello BodyAcid.ogg"], ["122 Amnesia Ibiza.zip", 1.0, "Ibiza", "Now Discs", "Amnesia", "Amnesia_Ibiza.ogg"], ["127 Granit Polar.zip", 0.0, "Polar", "JFX LAB", "GraniT", "Granit_Polar.ogg"], ["130 TheTown TheMovement.zip", 0.0, "The Movement", "ClekClekBoom", "The Town", "TheTown TheMovement.ogg"], ["118 Mondkopf Deadwood.zip", 0.0, "Deadwood", "In Paradisum", "Mondkopf", "Mondkopf_Deadwood.ogg"], ["131,7 DJPC ControlExpansion.zip", 4.0, "Control Expansion (DJPC Mix)", "Now Discs", "DJPC", "DJPC-ControlExpansion.ogg"], ["151,7 Feadz Metaman.zip", 1.5, "Metaman", "Ed Banger", "DJ Feadz", "Feadz-METAMAN.ogg"], ["118 DrafDodger M57.zip", -0.5, "M-57", "Midnight Trouble", "Draft Dodger", "mastered Go To The Moon.ogg"], ["128 FrenchFries BugNoticed.zip", 1.5, "Bug Noticed", "ClekClekBoom", "French Fries", "FrenchFries_BugNoticed.ogg"], ["127 Brodinski Oblivion.zip", -2.0, "Oblivion (Noob remix)", "Turbo Recordings", "Brodinski", "Brodinski_Oblivion(NoobRemix).ogg"], ["102 Oliver LightYearsAway.zip", -1.0, "Light Years Away", "Fool\'s Gold Records", "Oliver", "Oliver - Light Years Away (Instrumental).ogg"], ["125,94 PleasureGame AcrossTheDark.zip", 4.0, "Across the Dark", "Now Discs", "Pleasure Game", "PleasureGame Across the Dark.ogg"], ["128 JeanNipon Rosso.zip", -1.0, "Rosso", "Midnight Munchies", "Jean Nipon", "JeanNipon_ROSSO.ogg"]]');
}

//.Replace(":/", "/");
// const string MEDIA_SOUNDS_TURBO = "file:///" + IO::FromUserGameFolder("Media/Sounds/Turbo/").Replace("\\", "/");
// const string MEDIA_SOUNDS_TURBO = "file:///" + IO::FromUserGameFolder("Media/Sounds/Turbo/").Replace("\\", "/").SubStr(3);
// const string MEDIA_SOUNDS_TURBO = IO::FromUserGameFolder("Media/Sounds/Turbo/").Replace("\\", "/");
// const string MEDIA_SOUNDS_TURBO = "file:///Users/XertroV/Documents/Trackmania/Media/Sounds/Turbo/";
const string MEDIA_SOUNDS_TURBO = "file://Media/Sounds/Turbo/";

const CAudioScriptMusic::EUpdateMode TurboMusicUpdateMode = CAudioScriptMusic::EUpdateMode::OnNextHalfBar;

const float C_VMAX = 10.;

bool _hasInitializedFids = false;

bool InitializeMusicFids() {
    if (_hasInitializedFids) return true;
    auto zipFile = Fids::GetUser("TurboMusic.zip");
    if (zipFile is null) {
        warn("Could not find TurboMusic.zip");
        return false;
    }
    CPlugFileZip@ zipNod = cast<CPlugFileZip>(Fids::Preload(zipFile));
    if (zipNod !is null) {
        zipNod.MwAddRef();
        // zipNod.UiInstallFids();
        zipNod.UiInstallFidsInSubFolder();
        _hasInitializedFids = true;
        return true;
    } else {
        warn("Could not preload TurboMusic.zip");
    }
    return false;
}

namespace TurboConst {
    string SoundFinishLine = "130 Finish Line.ogg";
    string SoundStartLine = "starting.ogg";
    string SoundStartLine2 = "starting2.ogg";
    // string SoundStartLine = "130 Start.ogg";

    string MusicStandBy0 = "110 Pit Stop Twang - Military Loop1.ogg";
    string MusicStandBy1 = "110 Pit Stop Twang - Military Loop2.ogg";
    string MusicStandBy2 = "110 Pit Stop Twang - Military Loop3.ogg";
    string MusicReplay = "MusicReplay.ogg";

    string GetMusicStandBy() {
        switch (Math::Rand(0, 2)) {
            case 0: return MusicStandBy0;
            case 1: return MusicStandBy1;
            case 2: return MusicStandBy2;
        }
        return MusicStandBy0;
    }

    string SoundGameStart = "110 Pit Stop Military BONGO END NOTE For Random.ogg";

    // append number + .ogg
    string SoundCheckpointFast = "130 Checkpoint Fast ";
    string SoundCheckpointFast0 = "130 Checkpoint Fast 1.ogg";
    string SoundCheckpointFast1 = "130 Checkpoint Fast 2.ogg";
    string SoundCheckpointFast2 = "130 Checkpoint Fast 3.ogg";
    string SoundCheckpointFast3 = "130 Checkpoint Fast 4.ogg";
    string SoundCheckpointFast4 = "130 Checkpoint Fast 5.ogg";
    string SoundCheckpointFast5 = "130 Checkpoint Fast 6.ogg";
    string SoundCheckpointFast6 = "130 Checkpoint Fast 7.ogg";
    string SoundCheckpointFast7 = "130 Checkpoint Fast 8.ogg";

    // append number + .ogg
    string SoundCheckpointSlow = "130 Checkpoint Slow ";
    string SoundCheckpointSlow0 = "130 Checkpoint Slow 1.ogg";
    string SoundCheckpointSlow1 = "130 Checkpoint Slow 2.ogg";
    string SoundCheckpointSlow2 = "130 Checkpoint Slow 3.ogg";
    string SoundCheckpointSlow3 = "130 Checkpoint Slow 4.ogg";
    string SoundCheckpointSlow4 = "130 Checkpoint Slow 5.ogg";
    string SoundCheckpointSlow5 = "130 Checkpoint Slow 6.ogg";
    string SoundCheckpointSlow6 = "130 Checkpoint Slow 7.ogg";
    string SoundCheckpointSlow7 = "130 Checkpoint Slow 8.ogg";
}

Json::Value@ TurboMusicList = GetTurboMusicListJson();

namespace Turbo {
    void OnDestroyed() {
        // return;
        auto audio = cast<CTrackMania>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.Audio;
        // CleanupMusic(audio, G_Music);
        for (uint i = 0; i < G_MusicAll.Length; i++) {
            CleanupMusic(audio, G_MusicAll[i]);
        }
        CleanupSound(audio, G_MusicStandby);
        CleanupSound(audio, G_SoundStandbyEvent);
        CleanupSound(audio, G_MusicReplay);
    }

    void CleanupMusic(CAudioScriptManager@ audio, CAudioScriptMusic@ music) {
        if (music !is null) {
            music.Stop();
            audio.DestroyMusic(music);
        }
    }

    void CleanupSound(CAudioScriptManager@ audio, CAudioScriptSound@ sound) {
        if (sound !is null) {
            sound.Stop();
            audio.DestroySound(sound);
        }
    }

    CAudioScriptMusic@ G_Music;
    CAudioScriptMusic@[] G_MusicAll;
    Json::Value@[] G_MusicDescs;
    CAudioScriptSound@ G_MusicStandby;
    CAudioScriptSound@ G_SoundStandbyEvent;
    CAudioScriptSound@ G_MusicReplay;
    int G_PrevPlayedTrack = -1;

    int[] G_MusicRandomIndice;

    string G_Debug_SongName;
    int G_MusicDelay = 0;
    float G_MusicGain = 0.0;

    float G_Debug_LastTargetLPFratioFromSpeed = 0.0;

    void LoadMusic(int musicIx) {
        ResetSounds(true);
        if (G_MusicAll.Length < G_MusicDescs.Length) {
            G_MusicAll.Resize(G_MusicDescs.Length);
        }
        auto musicToPlay = musicIx;
        if (musicIx == -1) {
            musicToPlay = Math::Rand(0, G_MusicAll.Length - 1);
            // on relance une fois on a la même / we restart once we have the same
            if (G_PrevPlayedTrack == musicToPlay) {
                musicToPlay = Math::Rand(0, G_MusicAll.Length - 1);
            }
            G_PrevPlayedTrack = musicToPlay;
        }
        if (musicIx < -1) {
            musicToPlay = G_MusicAll.Length + musicIx + 1;
        }

        if (G_MusicAll[musicToPlay] !is null) {
            G_Debug_SongName = G_MusicDescs[musicToPlay][0];
            print("Loading music: " + G_Debug_SongName);
            @G_Music = G_MusicAll[musicToPlay]; // (la musique précédente qu'on ecrase est stoppée par ResetSounds() juste avant) / (the previous music we overwrite is stopped by ResetSounds() just before)
            G_Music.VolumedB = -39.;
            G_Music.FadeDuration = 0.35;
            G_Music.FadeTracksDuration = .5;


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
        if (G_MusicAll.Length != 0) {
            throw("G_MusicAll is not empty");
        }

        auto audio = cast<CTrackMania>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.Audio;
        for (uint i = 0; i < G_MusicDescs.Length; i++) {
            auto @j = G_MusicDescs[i];
            auto audioPath = MEDIA_SOUNDS_TURBO + string(j[0]);
            trace("Loading music: " + audioPath);
            G_MusicAll.InsertLast(
                audio.CreateMusic(audioPath)
            );
            if (G_MusicAll[i] is null) {
                warn("G_MusicAll[" + i + "] is null; file: " + audioPath);
            }
        }

        if (G_MusicStandby is null) {
            auto file = MEDIA_SOUNDS_TURBO + TurboConst::GetMusicStandBy();
            @G_MusicStandby = audio.CreateSoundEx(file, GetVolumedB("MusicStandBy"), true, true, false);
            if (G_MusicStandby is null) {
                warn("G_MusicStandby is null; file: " + file);
            }
            // if ({{{_IsTrackbuilder}}}) yield;
            G_MusicStandby.Stop();
            G_MusicStandby.VolumedB = GetVolumedB("MusicStandBy");
            G_MusicStandby.PanRadiusLfe = GetMusicPanRadiusLfe(VolumeCase::MusicStandby);
            @G_SoundStandbyEvent = audio.CreateSoundEx(MEDIA_SOUNDS_TURBO + TurboConst::SoundGameStart, GetVolumedB("MusicStandBy"), true, false, false);
            G_SoundStandbyEvent.PanRadiusLfe = G_MusicStandby.PanRadiusLfe;
        }

        if (G_MusicReplay is null) {
            @G_MusicReplay = audio.CreateSoundEx(MEDIA_SOUNDS_TURBO + TurboConst::MusicReplay, GetVolumedB("MusicReplay"), true, true, false);
            // if ({{{_IsTrackbuilder}}}) yield;
            G_MusicReplay.Stop();
            G_MusicReplay.VolumedB = GetVolumedB("MusicReplay");
            G_MusicReplay.PanRadiusLfe = GetMusicPanRadiusLfe(VolumeCase::MusicReplay);
        }
    }

    CAudioScriptSound@ G_SoundFinishLine;
    CAudioScriptSound@ G_SoundStartLine2;
    CAudioScriptSound@ G_SoundStartLine;
    CAudioScriptSound@[] G_CheckpointSlow;
    CAudioScriptSound@[] G_CheckpointFast;
    void PreloadSounds() {
        PreloadMusic();
        LoadMusic(-1);

        auto audio = cast<CTrackMania>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.Audio;
        @G_SoundFinishLine = audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundFinishLine);
        @G_SoundStartLine = audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundStartLine);
        @G_SoundStartLine2 = audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundStartLine2);

        G_CheckpointSlow.Resize(8);
        for (uint i = 0; i < 8; i++) {
            @G_CheckpointSlow[i] = audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundCheckpointSlow + i + ".ogg");
        }

        G_CheckpointFast.Resize(8);
        for (uint i = 0; i < 8; i++) {
            @G_CheckpointFast[i] = audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundCheckpointFast + i + ".ogg");
        }
        // if ({{{_IsTrackbuilder}}}) yield;
    }

    void OnStartRace_Reset() {
        G_Music.LPF_CutoffRatio = 0.25;
        G_Music.UpdateMode = TurboMusicUpdateMode;
        G_Music.Dbg_ForceSequential = false;
        G_Music.Dbg_ForceIntensity = false;
        G_Music.Dbg_ForceRandom = false;
        G_Music.EnableSegment("lap");
        SetMusicLevel();
        G_Music.Play();
        trace("G_Music.Play() " + G_Music.IdName);
#if DEV
        // ExploreNod(G_Music);
#endif
    }

    void SetMusicLevel() {
        {
            // if normal
            G_Music.VolumedB = (-8.5 - 1.0) * 0.0;
            // if boosted
            // if muted
        }
        G_Music.PanRadiusLfe = GetMusicPanRadiusLfe();
    }

    enum VolumeCase {
        MusicIngame,
        MusicPause,
        MusicReplay,
        MusicStandby,
        MusicMenu,
        MusicIntro,
        MenuSFX,
        MenuAmbiance,
        MenuUISpreadLarge,
        MenuStartRace,
        TransitionIngameChopper,
        FinishLine,
        StateFlying,
        SpeedEffectStart,
    }

    vec3 GetMusicPanRadiusLfe(VolumeCase _Case = VolumeCase::MusicIngame) {
        switch (_Case) {
            case VolumeCase::MusicIngame: return vec3(0., 0.88, -24.);
            case VolumeCase::MusicPause: return vec3(0., 0.71, -21.);
            case VolumeCase::MusicReplay: return vec3(0., 0.71, -21.);
            case VolumeCase::MusicStandby: return vec3(0., 0.71, -21.);
            case VolumeCase::MusicMenu: return vec3(0., 1.,   -20.);
            case VolumeCase::MusicIntro: return vec3(0., 0.88, -14.);
            case VolumeCase::MenuSFX: return vec3(0., 0.35, -21.);
            case VolumeCase::MenuAmbiance: return vec3(0., 100., -21.);
            case VolumeCase::MenuUISpreadLarge: return vec3(0., 1.,   -14.);
            case VolumeCase::MenuStartRace: return vec3(0., 0.9,  -6.);
            case VolumeCase::TransitionIngameChopper: return vec3(0., 0.9,  -18.);
            case VolumeCase::FinishLine: return vec3(0., 0.7,  -20.);
            case VolumeCase::StateFlying: return vec3(0., 0.88, -100.);
            case VolumeCase::SpeedEffectStart: return vec3(0., 0.4, -16.);
        }
        warn("[GetPosX] : Can't find " + tostring(_Case));
        return vec3(0., 0., -100.);
    }

    // comes from game settings I think
    float G_Volume_Musics = 1.0;

    float GetMusicsVolume(float _volumeBase) {
        if (G_Volume_Musics <= 0.) return -99.;
        return _volumeBase + (C_VMAX * G_Volume_Musics - C_VMAX);
    }

    float GetVolumedB(const string &in sound) {
        // music replay: -1-6
        // ingame: -1
        // standby: -1-1
        if (sound == "MusicReplay") return GetMusicsVolume(-7.);
        if (sound == "MusicStandBy") return GetMusicsVolume(-2.);
        if (sound == "MusicBoosted") return -4.6;
        return -1.;
    }

    enum ERaceState {
        BeforeStart, Running, Finished, Eliminated
    }

    void SetSFXSceneLevel() {
        // ignore this; touches Audio.LimitSceneSoundVolumedB
    }

    void ResetSounds(bool _ResetStandby) {
        if (_ResetStandby) G_MusicStandby.Stop();
        if (_ResetStandby) G_MusicReplay.Stop();
        if (G_Music !is null) {
            G_Music.Stop();
            G_Music.VolumedB = -39.;
        }
    }

    void Main() {
        InitializeMusicFids();
        // audio.LimitSceneSoundVolumedB = Volumes::GetVolumedB("MainSFX");
        // G_MusicDescs.clear()
        InitRandomMusicIndicies();
        PreloadSounds();
        while (true) {
            yield();
            OnRaceStateUpdate(GetCurrentRaceState());
        }
    }

    void InitRandomMusicIndicies() {
        auto musicCount = TurboMusicList.Length;
        G_MusicRandomIndice.Resize(musicCount);
        for (uint i = 0; i < musicCount; i++) {
            G_MusicRandomIndice[i] = i;
        }
        for (uint i = 0; i < musicCount; i++) {
            auto j = Math::Rand(i, musicCount - 1);
            auto tmp = G_MusicRandomIndice[i];
            G_MusicRandomIndice[i] = G_MusicRandomIndice[j];
            G_MusicRandomIndice[j] = tmp;
        }
        G_MusicDescs.Reserve(musicCount);
        for (uint i = 0; i < musicCount; i++) {
            G_MusicDescs.InsertLast(TurboMusicList[G_MusicRandomIndice[i]]);
        }

    }

    CSmPlayer@ GetCurrentPlayer(CGameCtnApp@ app) {
        try { return cast<CSmPlayer>(app.CurrentPlayground.GameTerminals[0].ControlledPlayer); }
        catch { return null; }
    }

    ERaceState GetCurrentRaceState() {
        try {
            auto app = GetApp();
            if (app.CurrentPlayground is null) return ERaceState::BeforeStart;
            auto gt = app.CurrentPlayground.GameTerminals[0];
            auto player = cast<CSmPlayer>(gt.GUIPlayer);
            if (player is null) return ERaceState::Finished;
            auto ps = cast<CSmScriptPlayer>(player.ScriptAPI);
            if (ps.StartTime > GameTime) return ERaceState::BeforeStart;
            // if (ps.Post == CSmScriptPlayer::EPost::CarDriver) return ERaceState::Running;
            if (gt.UISequence_Current == SGamePlaygroundUIConfig::EUISequence::Finish) return ERaceState::Running;
            return ERaceState::Running;
            // return ERaceState::BeforeStart;
        } catch {
            warn("Exception getting race state: " + getExceptionInfo());
        }
        return ERaceState::BeforeStart;
    }

    int m_latestCheckpointForPlayers = -1;
    int m_raceStateTrigger_Finished = 0;
    bool m_isLastFinished = false;
    ERaceState m_lastRaceState = ERaceState::Eliminated;

    void OnRaceStateUpdate(ERaceState state) {
        bool stateChanged = m_lastRaceState != state;
        m_lastRaceState = state;
        // happens always
        switch (state) {
            case ERaceState::BeforeStart:
            case ERaceState::Eliminated:
                ResetSounds(false);
                m_latestCheckpointForPlayers = -1;
                m_isLastFinished = false;
                if (state == ERaceState::BeforeStart) {
                    SetSFXSceneLevel();
                }
        }

        // events business
        float currSpeed = UpdateEngineOrWaypointEvents(state, stateChanged);

        // happens only if state changed
        if (stateChanged) {
            warn("State changed: " + tostring(state));
            switch (state) {
                case ERaceState::BeforeStart:
                case ERaceState::Eliminated:
                    G_MusicReplay.Stop();
                    break;
                case ERaceState::Running:
                    SetSFXSceneLevel();
                    LoadMusic(-1);
                    ResetSounds(true);
                    OnStartRace_Reset();
                    print("Music started: " + G_Debug_SongName);
                    m_isLastFinished = false;
                    break;
                case ERaceState::Finished:
                    m_raceStateTrigger_Finished = GameTime;
                    // Audio.LimitSceneSoundVolumedB = {{{Volumes::GetVolumedB("MainSFX")-12.}}};
                    m_isLastFinished = true;
                    break;
            }
        }



        // net standby event
        // net replay event
        // net stop music event


        if (m_switchTrackNeeded) {
            m_switchTrackNeeded = false;
            G_Music.EnableSegment("loop");
            G_Music.NextVariant(); // rajouter le randommode après / add random mode after
            trace("Music: Switching track");
        }

        if (m_freewheelTrackNeeded) {
            m_freewheelTrackNeeded = false;
            G_Music.EnableSegment("freewheel");
            trace("Music: Freewheeling");
        }

        if (m_lapTrackNeeded) {
            m_lapTrackNeeded = false;
            // G_Music.EnableSegment("lap");
            G_Music.EnableSegment("loop");
            G_Music.NextVariant();
            trace("Music: Lap");
        }

        float TargetLPFratioFromSpeed = 0.25;
        float MinValue = 0.25;

        if (currSpeed < m_cutoffSpeedThreshold) {
            float MinSpeed = 75.;
            float Speed = Math::Max(currSpeed - MinSpeed, 0.0);
            float SpeedComp = m_cutoffSpeedThreshold - MinSpeed;

            TargetLPFratioFromSpeed = MinValue + (1.-MinValue) * (Speed / SpeedComp);
            if (m_isQuick) {
                // We lower the intensity of the loop
                G_Music.EnableSegment("loop");
                G_Music.NextVariant2(true); //rajouter le randommode après
                m_isQuick = false;
            }
        } else {
            m_isQuick = true;
            TargetLPFratioFromSpeed = 1.0;
        }

        bool Net_IsPauseMenuEnabled = false;

        bool isPaused = Net_IsPauseMenuEnabled || m_isLastFinished;
        if (m_isPaused != isPaused) {
            m_isPaused = isPaused;
            if (isPaused) {
                // Audio.LimitMusicVolumedB = -3.;
            } else {
                // Audio.LimitMusicVolumedB = 0.;
                // SetSFXSceneLevel();
            }
        }

        G_Debug_LastTargetLPFratioFromSpeed = TargetLPFratioFromSpeed;
        if (!m_isPaused) {
            // trace("LPF: " + G_Music.LPF_CutoffRatio + " -> " + TargetLPFratioFromSpeed);
            G_Music.LPF_CutoffRatio = TargetLPFratioFromSpeed;
        } else {
            if (m_isLastFinished) {
                float max = TargetLPFratioFromSpeed;
                float duration = G_Music.BeatDuration * 40.;
                float time = 1. * (GameTime - m_raceStateTrigger_Finished - 1000); // / 1000.;
                SetMusicLevel();
                G_Debug_LastTargetLPFratioFromSpeed = easeOutCircle(time, max, (-max + 0.25), duration);
                G_Music.LPF_CutoffRatio = G_Debug_LastTargetLPFratioFromSpeed;
            }
        }
    }

    int GameTime;

    // returns current speed
    float UpdateEngineOrWaypointEvents(ERaceState state, bool stateChanged = false) {
        // check engine
        // check waypoint
        // - if finish, end lap, or added CP
        auto app = GetApp();
        GameTime = app.Network.PlaygroundInterfaceScriptHandler.GameTime;
        auto audio = cast<CTrackMania>(app).MenuManager.MenuCustom_CurrentManiaApp.Audio;
        auto player = GetCurrentPlayer(app);
        if (player is null) return 0.;

        auto playerScript = cast<CSmScriptPlayer>(player.ScriptAPI);
        playerCpIx = player.CurrentLaunchedRespawnLandmarkIndex;
        playerLapCount = playerScript.CurrentLapNumber;
        playerRespawned = playerScript.StartTime > GameTime;
        if (playerCpIx != lastPlayerCpIx || state == ERaceState::Finished) {
            if (state == ERaceState::Finished && stateChanged) {
                print("Playing finish line sound: " + TurboConst::SoundFinishLine);
                // end race?
                m_switchTrackNeeded = true;
                auto sound = audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundFinishLine);
                if (sound is null) {
                    warn("Sound is null: " + TurboConst::SoundFinishLine);
                }
                audio.PlaySoundEventMix(sound, 5.0, vec3());
            } else if (playerLapCount != lastPlayerLapCount && playerLapCount > 0) {
                // end lap?
                m_lapTrackNeeded = true;
            } else if (state == ERaceState::Running) {
                // cp count when up?
                if (!playerRespawned) {
                    m_latestCheckpointForPlayers = playerCpIx;
                    m_switchTrackNeeded = true;
                }
            }
        }
        lastPlayerLapCount = playerLapCount;
        lastPlayerCpIx = playerCpIx;


        CSceneVehicleVis@ vis;
        @vis = VehicleState::GetVis(app.GameScene, player);
        if (vis is null) return 0.;
        isEngineOff = !vis.AsyncState.EngineOn;
        if (isEngineOff != wasEngineOff) {
            wasEngineOff = isEngineOff;
            if (isEngineOff) {
                m_freewheelTrackNeeded = true;
            } else {
                m_switchTrackNeeded = true;
            }
        }

        return vis.AsyncState.WorldVel.Length() * 3.6;
    }

    // t: current time, b: beginning value, c: change in value, d: duration
    float easeOutCircle(float t, float b, float c, float d) {
        t /= d;
        t -= 1.0;
        t = Math::Min(t, 0.9999);
        // trace('t: ' + t + ' b: ' + b + ' c: ' + c + ' d: ' + d);
        return c * Math::Sqrt(1. - t*t) + b;
    }

    // case "Canyon" 	: M_CutoffSpeedTreshold = 250.;
    // case "Valley"  	: M_CutoffSpeedTreshold = 175.;
    // case "Lagoon" 	: M_CutoffSpeedTreshold = 125.;
    // case "Stadium" 	: M_CutoffSpeedTreshold = 225.;
    // default 		: M_CutoffSpeedTreshold = 250.;

    float m_cutoffSpeedThreshold = 175.;
    bool m_isQuick = false;
    bool m_isPaused = false;
    bool m_freewheelTrackNeeded = false;
    bool m_switchTrackNeeded = false;
    bool m_lapTrackNeeded = false;

    // update each frame
    bool isEngineOff = false;
    bool wasEngineOff = false;
    uint playerCpIx = 0xFFFFFFFF;
    uint lastPlayerCpIx = 0xFFFFFFFF;
    uint playerLapCount = 0;
    uint lastPlayerLapCount = 0;
    bool playerRespawned = false;
}








// Meta::PluginCoroutine@ tmusictest = startnew(TMusicTest);

// TurboMusic@ g_turboMusic;
// string[]@ g_turboMusicPaths;

// string[]@ TurboMusicPaths() {
//     auto dir = "C:/Users/xertrov/OpenplanetTurbo/Extract/Media/Sounds/TMConsole/Loops";
//     auto files = IO::IndexFolder(dir, false);
//     string[] paths;
//     for (uint i = 0; i < files.Length; i++) {
//         if (files[i].EndsWith("/")) {
//             paths.InsertLast(GetLastDirName(files[i]));
//         }
//     }
//     print("Found " + paths.Length + " TurboMusic paths; " + Json::Write(paths.ToJson(), true));
//     return paths;
// }

// void TMusicTest() {
//     @g_turboMusicPaths = TurboMusicPaths();
//     // LoadRandomTurboMusic();
// }

// void LoadRandomTurboMusic() {
//     if (g_turboMusic !is null) g_turboMusic.StopAll();
//     @g_turboMusic = TurboMusic("C:/Users/xertrov/OpenplanetTurbo/Extract/Media/Sounds/TMConsole/Loops/" + g_turboMusicPaths[Math::Rand(0, g_turboMusicPaths.Length)]);
// }


// class NamedSample {
//     Audio::Sample@ sample;
//     string name;
//     int intensity;
//     TurboMusicLayer@ layer;

//     NamedSample(Audio::Sample@ s, const string &in name, int intensity) {
//         @sample = s;
//         this.name = name;
//         this.intensity = intensity;
//         @layer = TurboMusicLayer(this, 1.0, MusicFading::FadeIn, false);
//     }

// }


// class TurboMusic : Music {
//     string turboDirPath;

//     NamedSample@ sLap;
//     NamedSample@ sFreewheel;
//     NamedSample@[] sLoop;

//     TurboMusic(const string &in path) {
//         turboDirPath = path.Replace("\\", "/");
//         auto pathParts = turboDirPath.Split("/");
//         // name is the last part of the path
//         super(pathParts[pathParts.Length - 1]);
//         LoadXML(turboDirPath + "/settings.xml");
//         print("Loaded TurboMusic: " + path);
//         PrintJson();
//         yield();
//         // PlayAll();
//         StartPlaying();
//     }


//     NamedSample@ LoadSample(const string &in audioName, int intensity) {
//         auto fullPath = turboDirPath + "/Tracks/" + audioName + ".ogg";
//         if (!IO::FileExists(fullPath)) {
//             warn("File does not exist: " + fullPath);
//             return null;
//         }
//         print("Loading sample: " + fullPath);
//         Audio::Sample@ s = Audio::LoadSample(ReadFileToBuf(fullPath), false);
//         // auto v = Audio::Play(s, 0.5);
//         // sleep(v.GetLength() * 1000);
//         return NamedSample(s, audioName, intensity);
//     }

//     void StopAll() {
//         for (uint i = 0; i < layers.Length; i++) {
//             layers[i].voice.SetGain(0.0);
//         }
//         IsPlaying = false;
//     }

//     void LoadXML(const string &in xmlPath) {
//         XML::Document@ doc = XML::Document(ReadFileToString(xmlPath));
//         XML::Node root = doc.Root();
//         auto music = root.Child("music");
//         auto mChild = music.FirstChild();
//         while (mChild) {
//             ParseMusicChild(mChild);
//             mChild = mChild.NextSibling();
//         }
//     }

//     void ParseMusicChild(XML::Node &in node) {
//         auto name = node.Name();
//         if (name == "segment") ParseSegmentNode(node);
//         else if (name == "tempo") ParseTempoNode(node);
//         else warn("Unknown node: " + name);
//     }

//     // beats per minute
//     float bpm;
//     // seconds per beat
//     float spb;
//     // beats per bar
//     float bpb;

//     float get_CrossfadeDuration() {
//         return (bpm / 60.0 * 4.0) * 0.5;
//     }

//     void ParseTempoNode(XML::Node &in node) {
//         bpm = Text::ParseFloat(node.Attribute("beatsperminute"));
//         bpb = Text::ParseFloat(node.Attribute("beatsperbar"));
//         spb = 60.0 / bpm;
//     }

//     void ParseSegmentNode(XML::Node &in node) {
//         auto name = node.Attribute("name");
//         print("Segment: " + name);
//         if (name == "loop") ParseSegmentLoopNode(node);
//         else if (name == "lap") ParseSegmentLapNode(node);
//         else if (name == "freewheel") ParseSegmentFreewheelNode(node);
//         else warn("Unknown segment: " + name);
//     }

//     string lapVariantName;
//     int lapVariantIntensity;

//     void ParseSegmentLapNode(XML::Node &in node) {
//         auto tg = node.Child("trackgroup");
//         auto var = tg.Child("variant");
//         lapVariantName = var.Attribute("name");
//         lapVariantIntensity = Text::ParseInt(var.Attribute("intensity"));
//         @sLap = this.LoadSample(lapVariantName, lapVariantIntensity);
//     }

//     string freewheelVariantName;
//     int freewheelVariantIntensity;

//     void ParseSegmentFreewheelNode(XML::Node &in node) {
//         auto tg = node.Child("trackgroup");
//         auto var = tg.Child("variant");
//         freewheelVariantName = var.Attribute("name");
//         freewheelVariantIntensity = Text::ParseInt(var.Attribute("intensity"));
//         @sFreewheel = this.LoadSample(freewheelVariantName, freewheelVariantIntensity);
//     }

//     uint loopVariantMaxCycles;
//     string loopVariantOrder;

//     void ParseSegmentLoopNode(XML::Node &in node) {
//         loopVariantMaxCycles = Text::ParseUInt(node.Attribute("variant_maxcycles"));
//         auto tg = node.Child("trackgroup");
//         loopVariantOrder = tg.Attribute("variant_order");
//         ParseTrackGroup(tg);
//     }

//     TGVariant[] trackGroupVariants;
//     int minIntensity = 999;
//     int maxIntensity = -1;

//     void ParseTrackGroup(XML::Node &in node) {
//         auto child = node.FirstChild();
//         string name;
//         while (child) {
//             name = child.Name();
//             if (name == "variant") {
//                 trackGroupVariants.InsertLast(TGVariant(child));
//                 auto @var = trackGroupVariants[trackGroupVariants.Length - 1];
//                 if (var.intensity < minIntensity) minIntensity = var.intensity;
//                 if (var.intensity > maxIntensity) maxIntensity = var.intensity;
//                 auto ns = this.LoadSample(var.name, var.intensity);
//                 if (ns !is null) {
//                     sLoop.InsertLast(ns);
//                 } else {
//                     trackGroupVariants.RemoveLast();
//                 }
//             } else {
//                 warn("Unknown trackgroup child: " + name);
//             }
//             child = child.NextSibling();
//         }
//         print("Min intensity: " + minIntensity);
//         print("Max intensity: " + maxIntensity);
//     }

//     void PrintNode(XML::Node &in node, int depth = 0) {
//         print(SPACE_PAD.SubStr(0, depth*2) + "- " + node.Name());
//         auto child = node.FirstChild();
//         while (child) {
//             PrintNode(child, depth + 1);
//             child = child.NextSibling();
//         }
//     }

//     Json::Value@ ToJson() {
//         auto @root = Json::Object();
//         root["name"] = name;
//         root["bmp"] = bpm;
//         root["bpb"] = bpb;
//         auto @segments = Json::Array();
//         for (uint i = 0; i < trackGroupVariants.Length; i++) {
//             auto variant = Json::Object();
//             variant["name"] = trackGroupVariants[i].name;
//             variant["intensity"] = trackGroupVariants[i].intensity;
//             variant["subgroups"] = trackGroupVariants[i].subgroups;
//             segments.Add(variant);
//         }

//         auto @freewheelSegment = Json::Object();
//         freewheelSegment["name"] = freewheelVariantName;
//         freewheelSegment["intensity"] = freewheelVariantIntensity;
//         auto @lapSegment = Json::Object();
//         lapSegment["name"] = lapVariantName;
//         lapSegment["intensity"] = lapVariantIntensity;

//         root["segments"] = segments;
//         root["freewheel"] = freewheelSegment;
//         root["lapSegment"] = lapSegment;

//         return root;
//     }

//     void PrintJson() {
//         print(Json::Write(this.ToJson(), true));
//     }




//     void Debug_PlayAll() {
//         for (uint i = 0; i < sLoop.Length; i++) {
//             WaitTillDone(Audio::Play(sLoop[i].sample, 0.5));
//         }
//         auto v = Audio::Play(sFreewheel.sample, 0.5);
//         WaitTillDone(v);
//         @v = Audio::Play(sLap.sample, 0.5);
//         WaitTillDone(v);
//     }




//     void StartPlaying() {
//         startnew(CoroutineFunc(this.PlayLoop)).WithRunContext(MUSIC_RUN_CTX);
//     }

//     TurboMusicLayer@[] layers;

//     int currIntensity = 0;
//     // probability we will swap to a new variant
//     float swapVariantP = .5;

//     bool IsPlaying = false;

//     void PlayLoop() {
//         IsPlaying = true;
//         currIntensity = minIntensity;
//         swapVariantP = 2.0 / loopVariantMaxCycles;

//         while (IsPlaying) {
//             if (layers.Length == 0) {
//                 FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration);
//             } else {
//                 CheckForDoneLayersAndUpdate();
//             }
//             yield();
//         }
//     }


//     bool FindAndPlayVariant(int intensity, MusicFading fade, float cfDuration, const string &in nameNot = "", float pos = 0.0) {
//         print("FindAndPlayVariant: " + intensity + " fade: " + fade + " cfDuration: " + cfDuration + " nameNot: " + nameNot);

//         auto varDist = 0;
//         auto namedSample = FindVariant(intensity, varDist, nameNot);
//         while (namedSample is null && varDist < 5) @namedSample = FindVariant(intensity, ++varDist, nameNot);
//         if (namedSample is null) {
//             warn("No variant found for intensity: " + intensity);
//             return false;
//         }
//         print("Playing variant: " + namedSample.name);
//         // layers.InsertLast(TurboMusicLayer(namedSample, cfDuration, fade));
//         layers.InsertLast(namedSample.layer);
//         namedSample.layer.ResetFadeIn(pos);
//         // currIntensity = namedSample.intensity;
//         return true;
//     }

//     NamedSample@ FindVariant(int intensity, int dist, const string &in nameNot = "") {
//         uint startIx = Math::Rand(0, sLoop.Length - 1);
//         uint modIx = sLoop.Length;
//         for (uint i = 0; i < trackGroupVariants.Length; i++) {
//             uint ix = (startIx + i) % modIx;
//             if (Math::Abs(trackGroupVariants[ix].intensity - intensity) <= dist && trackGroupVariants[ix].name != nameNot && !sLoop[ix].layer.IsPlaying) {
//                 return sLoop[ix];
//             }
//         }
//         if (Math::Abs(lapVariantIntensity - intensity) <= dist && lapVariantName != nameNot && !sLap.layer.IsPlaying) {
//             return sLap;
//         }
//         if (Math::Abs(freewheelVariantIntensity - intensity) <= dist && freewheelVariantName != nameNot && !sFreewheel.layer.IsPlaying) {
//             return sFreewheel;
//         }
//         return null;
//     }

//     void UpdateIntensity() {
//         auto p = VehicleState::GetViewingPlayer();
//         if (p is null) return;
//         auto v = VehicleState::GetVis(GetApp().GameScene, p);
//         if (v is null) return;
//         currIntensity = int(Math::Round(Math::Lerp(float(minIntensity), float(maxIntensity), Math::Clamp(Math::InvLerp(100.0, 500.0, 3.6*v.AsyncState.FrontSpeed), 0.0, 1.0))));
//     }

//     int trackUpperLim = 2;
//     bool doneFirst = false;

//     void CheckForDoneLayersAndUpdate() {
//         UpdateIntensity();
//         if (layers.Length == 0) return;

//         float pos = layers[0].voice.GetPosition();
//         float len = layers[0].voice.GetLength();
//         bool l0Done = layers[0].IsDone;
//         if (l0Done) pos = layers[0].lastPosDelta - layers[0].finalPartial;

//         IsOnBeat = Math::Abs(((pos + g_dt * .5) % spb)) < g_dt;

//         if (!doneFirst && l0Done) {
//             doneFirst = true;
//             FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration, layers[layers.Length - 1].name, pos);
//         }

//         for (int i = layers.Length - 1; i >= 0; i--) {
//             if (i > 0 && Math::Abs(layers[i].voice.GetPosition() - pos) > 0.015) {
//                 layers[i].SetPosition(pos);
//             }
//             if (layers[i].Update()) {
//                 auto @layer = layers[i];
//                 print("Layer done: " + layer.name);
//                 layers.RemoveAt(i);
//                 switch (layer.fade) {
//                     // FadeIn: repeat
//                     // None: repeat
//                     //    - but if it's the only one, a chance to swap to a new variant (which means fade out and add new variant)
//                     // FadeOut: remove
//                     case MusicFading::FadeIn:
//                         layer.ResetNoFade(pos);
//                         layers.InsertLast(layer);
//                         trace("Repeating layer (faded in): " + layer.name);
//                         break;
//                     case MusicFading::None: {
//                         bool hasRoom = layers.Length < trackUpperLim;
//                         // layer.Repetitions < loopVariantMaxCycles
//                         if (hasRoom && Math::Rand(.0, 1.0) < swapVariantP) {
//                             trace("Swapping variant: " + layer.name);
//                             layer.ResetFadeOut(pos);
//                             layers.InsertLast(layer);
//                             FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration, layer.name, pos);
//                         } else if (currIntensity == layer.intensity || layers.Length == 0) {
//                             trace("Repeating layer: " + layer.name);
//                             layer.ResetNoFade(pos);
//                             layers.InsertLast(layer);
//                         } else {
//                             layer.ResetFadeOut(pos);
//                             layers.InsertLast(layer);
//                             print("layers.Length: " + layers.Length);
//                             print("currIntensity: " + currIntensity + " layer.intensity: " + layer.intensity);
//                             print("Dropping layer: " + layer.name);
//                             if (layers.Length == 1) {
//                                 FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration, layer.name, pos);
//                             }
//                         }

//                         if (layers.Length < trackUpperLim - 1 && Math::Rand(.0, 1.0) < swapVariantP) {
//                             FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration, layer.name, pos);
//                         }
//                         break;
//                     }
//                     case MusicFading::FadeOut:
//                         // layer.voice.Pause();
//                         layer.NullifyVoice();
//                         // layer.voice.SetPosition(0.0);
//                         break;
//                 }
//             }
//         }


//         bool allFadingOut = true;
//         for (uint i = 0; i < layers.Length; i++) {
//             if (!layers[i].IsFadingOut) {
//                 allFadingOut = false;
//                 break;
//             }
//         }
//         if (allFadingOut) {
//             layers[0].ResetNoFade(pos);
//             FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration, layers[0].name, pos);
//         }

//         float firstPos = layers[0].voice.GetPosition();
//         if (firstPos < 0.01) {
//             bool anyCorrectIntensity = false;
//             for (uint i = 0; i < layers.Length; i++) {
//                 if (layers[i].intensity == currIntensity) {
//                     anyCorrectIntensity = true;
//                     break;
//                 }
//             }
//             if (!anyCorrectIntensity) {
//                 layers[0].ResetFadeOut(pos);
//                 FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration * .2, "", pos);
//             }

//             for (uint i = 1; i < layers.Length; i++) {
//                 layers[i].SetPosition(firstPos);
//             }
//         }

//     }

//     bool IsOnBeat;
// }

// enum MusicFading {
//     None,
//     FadeIn,
//     FadeOut
// }

// class TurboMusicLayer {
//     NamedSample@ s;
//     Audio::Sample@ sample;
//     Audio::Voice@ voice;
//     string name;
//     float crossfadeDuration;
//     bool isFadingOut;
//     // crossfade progress [0, 1], start, end
//     float cfP, cfStart, cfEnd;
//     vec2 volStartEnd;
//     float currVol;
//     int intensity;
//     float duration;
//     float progress;
//     float Repetitions;

//     ~TurboMusicLayer() {
//         print("Destroying TurboMusicLayer: " + name);
//         if (voice !is null) {
//             voice.SetGain(0.0);
//             @voice = null;
//         }
//     }


//     TurboMusicLayer(NamedSample@ s, float crossfadeDuration = 1.0, MusicFading fade = MusicFading::FadeIn, bool playImmediately = true) {
//         @this.s = s;
//         @this.sample = s.sample;
//         this.name = s.name;
//         this.intensity = s.intensity;
//         this.crossfadeDuration = crossfadeDuration;
//         this.cfP = crossfadeDuration > 0.0 ? 0.0 : 1.0;
//         this.cfStart = 0.0;
//         this.cfEnd = crossfadeDuration;
//         this.fade = fade;
//         switch (fade) {
//             case MusicFading::FadeIn:
//                 volStartEnd.x = 0.0;
//                 volStartEnd.y = 1.0;
//                 break;
//             case MusicFading::FadeOut:
//                 volStartEnd.x = 1.0;
//                 volStartEnd.y = 0.0;
//                 break;
//             default:
//                 volStartEnd = vec2(1.0);
//                 break;
//         }
//         currVol = volStartEnd.x;
//         SetVoiceUpdateAndStart(playImmediately);

//         if (fade == MusicFading::FadeOut) {
//             cfEnd = voice.GetLength();
//             cfStart = cfEnd - crossfadeDuration;
//         }
//     }

//     void SetPosition(float pos) {
//         trace("["+name+"] SetPosition: " + pos + " / " + (voice !is null));
//         if (voice is null) return;
//         // pos += g_dt
//         voice.SetPosition(Math::Max(pos, 0.0) + 0.01);
//     }

//     void SetVoiceUpdateAndStart(bool andStart = true) {
//         Update();
//         SetVoice();
//         if (andStart) StartVoice();
//     }

//     void NullifyVoice() {
//         if (voice !is null) {
//             voice.SetGain(0.0);
//             @voice = null;
//         }
//     }

//     void SetVoice() {
//         // if (voice is null)
//         NullifyVoice();
//         @this.voice = Audio::Start(this.sample);
//         voice.SetGain(currVol * Global::MusicVolume);
//         duration = voice.GetLength();
//         crossfadeDuration = duration * 0.7;
//     }

//     void StartVoice() {
//         voice.SetGain(currVol * Global::MusicVolume);
//         if (voice.IsPaused()) voice.Play();
//     }

//     void StartIfNotPlaying() {
//         if (voice.IsPaused()) {
//             voice.Play();
//         }
//     }

//     void OptionallyReplaceVoice() {
//         if (IsDone) {
//             SetVoice();
//         }
//     }

//     bool get_IsPlaying() {
//         return voice !is null && !voice.IsPaused();
//     }

//     void ResetFadeIn(float pos) {
//         cfP = 0.0;
//         fade = MusicFading::FadeIn;
//         volStartEnd = vec2(0.0, 1.0);
//         currVol = 0.0;
//         cfStart = 0.0;
//         cfEnd = crossfadeDuration;
//         SetVoice();
//         SetPosition(pos);
//         StartIfNotPlaying();
//         Repetitions++;
//         // print("ResetFadeIn: " + newPos);
//     }

//     void ResetNoFade(float pos) {
//         cfP = 1.0;
//         fade = MusicFading::None;
//         volStartEnd = vec2(1.0);
//         currVol = 1.0;
//         cfStart = 0.0;
//         cfEnd = crossfadeDuration;
//         SetVoice();
//         StartIfNotPlaying();
//         SetPosition(pos);
//         Repetitions++;
//         // print("ResetNoFade: " + newPos);
//     }

//     void ResetFadeOut(float pos) {
//         cfP = 0.0;
//         fade = MusicFading::FadeOut;
//         volStartEnd = vec2(1.0, 0.0);
//         currVol = 1.0;
//         SetVoice();
//         SetPosition(pos);
//         StartIfNotPlaying();
//         cfStart = duration - crossfadeDuration;
//         cfEnd = duration;
//         Repetitions = 0;
//         print("ResetFadeOut: " + pos + " / " + duration + " CF " + cfStart + " -> " + cfEnd);
//     }

//     MusicFading fade;
//     bool IsFadingOut {
//         get { return fade == MusicFading::FadeOut; }
//     }

//     float finalPartial, lastPosDelta, remaining, lastPos;

//     // returns true if done
//     bool Update(bool noDt = false) {
//         if (cfP < 1.0) {
//             // cfP = Math::Clamp(cfP + (noDt ? 0.0 : g_dt) / crossfadeDuration, 0.0, 1.0);
//             if (voice !is null && voice.GetPosition() >= cfStart) {
//                 cfP = Math::Clamp(cfP + (noDt ? 0.0 : g_dt) / crossfadeDuration, 0.0, 1.0);
//             }
//             currVol = Math::Lerp(volStartEnd.x, volStartEnd.y, EasedCfProgress());
//         }
//         progress += noDt ? 0.0 : g_dt;
//         if (voice !is null) {
//             voice.SetGain(currVol * Global::MusicVolume);
//         }
//         if (IsDone) {
//             finalPartial = voice.GetPosition() - lastPos;
//         } else if (voice !is null) {
//             lastPosDelta = voice.GetPosition() - lastPos;
//             remaining = voice.GetLength() - voice.GetPosition();
//             lastPos = voice.GetPosition();
//         }
//         return IsDone;
//     }

//     bool get_IsDone() {
//         return voice !is null && voice.GetPosition() >= voice.GetLength();
//     }

//     float EasedCfProgress() {
//         return QuadInOut(cfP);
//     }
// }


// float QuadInOut(float t) {
//     return t < 0.5 ? 2.0 * t * t : 1.0 - Math::Pow(-2.0 * t + 2.0, 2.0) / 2.0;
// }

// float LinearInOut(float t) {
//     return t;
// }


// class TGVariant {
//     string name;
//     int intensity;
//     int subgroups;
//     TGVariant() {}
//     TGVariant(XML::Node &in node) {
//         name = node.Attribute("name");
//         intensity = Text::ParseInt(node.Attribute("intensity"));
//         subgroups = Text::ParseInt(node.Attribute("subgroups"));
//     }
//     TGVariant(const string &in name, int intensity, int subgroups) {
//         this.name = name;
//         this.intensity = intensity;
//         this.subgroups = subgroups;
//     }
// }

// const string SPACE_PAD = "           ";



// string ReadFileToString(const string &in path) {
//     try {
//         IO::File file(path, IO::FileMode::Read);
//         return file.ReadToEnd();
//     } catch {
//         warn("Failed to read file: " + path);
//         warn("Error: " + getExceptionInfo());
//     }
//     return "";
// }

// MemoryBuffer@ ReadFileToBuf(const string &in path) {
//     try {
//         IO::File file(path, IO::FileMode::Read);
//         return file.Read(file.Size());
//     } catch {
//         warn("Failed to read file: " + path);
//         warn("Error: " + getExceptionInfo());
//     }
//     return null;
// }

// void WaitTillDone(Audio::Voice@ v) {
//     while (v.GetPosition() < v.GetLength()) {
//         yield();
//     }
// }


// string GetLastDirName(string path) {
//     path = path.Replace("\\", "/");
//     while (path.EndsWith("/")) path = path.SubStr(0, path.Length - 1);
//     auto parts = path.Split("/");
//     return parts[parts.Length - 1];
// }





// namespace TurboDebug {
//     bool window = true;

//     bool IsTurboMusicOnBeat() {
//         if (g_turboMusic is null) return false;
//         return g_turboMusic.IsOnBeat;
//     }

//     void RenderMenu() {
//         auto frameBgActive = UI::GetStyleColor(UI::Col::FrameBg);
//         if (IsTurboMusicOnBeat()) frameBgActive = vec4(0.0, 1.0, 0.0, 1.0);
//         UI::PushStyleColor(UI::Col::FrameBg, frameBgActive);
//         if (UI::MenuItem("TurboMusic Debug", "", window)) {
//             window = !window;
//         }
//         UI::PopStyleColor();
//     }

//     void Render() {
//         if (!window) return;
//         if (UI::Begin("TurboMusic Debug", window)) {
//             RenderInner();
//         }
//         UI::End();
//     }

//     void RenderInner() {
//         if (g_turboMusic is null) {
//             UI::Text("No TurboMusic loaded");
//             return;
//         }
//         if (UI::Button("Randomize Music")) {
//             startnew(LoadRandomTurboMusic);
//         }
//         if (UI::Button("Play All")) {
//             g_turboMusic.Debug_PlayAll();
//         }
//         UI::SameLine();
//         if (UI::Button("Start Playing")) {
//             g_turboMusic.StartPlaying();
//         }
//         UI::SameLine();
//         if (UI::Button("Stop Playing")) {
//             g_turboMusic.IsPlaying = false;
//         }
//         if (UI::Button("+ Intensity")) {
//             g_turboMusic.currIntensity = Math::Min(g_turboMusic.currIntensity + 1, g_turboMusic.maxIntensity);
//         }
//         UI::SameLine();
//         if (UI::Button("- Intensity")) {
//             g_turboMusic.currIntensity = Math::Max(g_turboMusic.currIntensity - 1, g_turboMusic.minIntensity);
//         }


//         UI::Text("Name: " + g_turboMusic.name);
//         UI::Text("Layers: " + g_turboMusic.layers.Length);
//         UI::Text("Curr Intensity: " + g_turboMusic.currIntensity);
//         for (uint i = 0; i < g_turboMusic.layers.Length; i++) {
//             UI::Text("Layer " + i);
//             UI::Indent();
//             UI::Text("Name: " + g_turboMusic.layers[i].name);
//             UI::Text("Intensity: " + g_turboMusic.layers[i].intensity);
//             UI::Text("Fading: " + g_turboMusic.layers[i].fade);
//             UI::Text("Position: " + Text::Format("%.6f", g_turboMusic.layers[i].voice.GetPosition()));
//             UI::Text("Length: " + g_turboMusic.layers[i].voice.GetLength());
//             UI::Text("IsDone: " + g_turboMusic.layers[i].IsDone);
//             auto v = g_turboMusic.layers[i].voice;
//             if (v !is null) {
//                 UI::Text("Gain: " + v.GetGain());
//                 UI::Text("Pos > Len: " + (v.GetPosition() > v.GetLength()));
//             }
//             UI::Text("cfP: " + g_turboMusic.layers[i].cfP);
//             UI::SliderFloat("CurrVol", g_turboMusic.layers[i].currVol, 0.0, 1.0);
//             UI::Unindent();
//         }
//     }
// }
