// TurboMusic@ ReadTurboMusicFromDirectory(const string &in path) {
//     return TurboMusic(path);
// }

Json::Value@ GetTurboMusicListJson() {
    // [[main file, gain, name, label, author, sample]]
    // note: we don't care about sample
    return Json::Parse('[["120 Breakbot ShadesOfBlack.zip", 1.5, "Shades of Black", "Ed Banger", "Breakbot", "Breakbot-Shades of black.ogg"], ["136 Cavart ClubSuede.zip", -0.5, "Club Suede", "Romain Cavart", "Cavart", "Cavart_ClubSuede.ogg"], ["124 4getMeNot ABroad.zip", 1.0, "AB ROAD", "Jarring Effects", "4GetMeNot", "4GetMeNot_ABroad.ogg"], ["87 Bustre Combine.zip", -0.5, "Combine", "Monstercat", "Bustre", "Bustre_Combine.ogg"], ["128 Bleaker Untitled.zip", 2.5, "Untitled", "Bleaker", "Bleaker", "Bleaker-Untitled.ogg"], ["126,4 DJPC GoToTheMoon.zip", 2.0, "Go To The Moon", "Now Discs", "DJPC", "DraftDodger_M-57.ogg"], ["126 Aethority DirtyJose.zip", 5.0, "Dirty Jose", "Living Large Publishing / Schubert Music Publishing", "Aethority", "Aethority_DirtyJose.ogg"], ["119 Costello Primal.zip", -2.0, "Primal", "Boysnoize Records", "Costello", "Costello_-_Primal.ogg"], ["130 Photonz Xabregas.zip", 1.5, "Xabregas", "One Eyed Jacks", "Photonz", "Photonz - Xabregas.ogg"], ["126 Don Rimini AdamandEve.zip", 1.5, "Adam & Eve (Dub)", "Brooklyn Fire Records", "Don Rimini", "DonRimini_AdamAndEve.ogg"], ["122 Mitch MurderBreeze.zip", 0.5, "Breeze", "Mad Decent", "Mitch Murder", "Mitch Murder - Breeze.ogg"], ["130 TWR72 Stefan.zip", 0.5, "Stefan", "Turbo Recordings", "TWR72", "TWR72_-_Stefan.ogg"], ["130 Granit Cris.zip", 0.0, "Cris", "JFX LAB", "GraniT", "Granit_Cris.ogg"], ["132 Photonz Babalon.zip", 2.5, "Babalon", "Photonz", "Photonz", "Photonz_Babalon.ogg"], ["140 DraftDodger 928GTS.zip", 0.0, "928 GTS", "Midnight Trouble", "Draft Dodger", "DraftDodger_928GTS.ogg"], ["130 TWR72 Steie.zip", 1.0, "Steie", "Turbo Recordings", "TWR72", "TWR72_-_Steie.ogg"], ["133.41 Grassilac ShooBeeDoo.zip", 3.0, "Shoo Bee Doo", "Now Discs", "Grassilac", "Grassilac Shoo Bee Doo.ogg"], ["126 Benoit B Traxxmen.zip", 3.0, "TraxxMen", "Beno\\u00eet Bovis", "Benoit B.", "Benoit_B-Traxxmen.ogg"], ["130 StripSteve Metadata.zip", -1.0, "Metadata", "Boysnoize Records", "Strip Steve", "Strip_Steve_-_Metadata.ogg"], ["118 DJ Pone ErroticImpulses.zip", 1.5, "Errotic Impulses", "Ed Banger Records", "Dj Pone ft. Arnaud Rebotini", "DJPone_ErroticImpulses.ogg"], ["125 Randomer NoHook.zip", 1.0, "No Hook", "Turbo Recordings", "Randomer", "Randomer_-_No_Hook.ogg"], ["129 Coni Flip.zip", 0.0, "Flip", "ClekClekBoom", "Coni", "Coni_Flip.ogg"], ["126 Qoso Jura.zip", 0.0, "Jura", "In Paradisum", "Qoso", "Qoso_Jura.ogg"], ["120 MitchMurder Breakazoid.zip", 0.5, "Breakazoid", "Mad Decent", "Mitch Murder", "Mitch Murder - Breakazoid.ogg"], ["126 Rushmore Sensation.zip", 1.5, "Sensation", "Rushmore", "Rushmore", "Rushmore-Sensation.ogg"], ["104 BusyP RainbowMan.zip", 3.0, "Rainbow Man", "Ed Banger", "Busy P", "BusyP_RainbowMan.ogg"], ["140 DeonCustom  Roses.zip", -1.0, "Roses", "Monstercat", "Deon Custom", "DeonCustom_Roses.ogg"], ["135 DraftDodger Choon.zip", 1.5, "Choon", "Draft Dodger", "Draft Dodger", "DraftDodger-Choon.ogg"], ["128 Photonz Errortrak.zip", -2.0, "Errortrak", "Photonz", "Photonz", "Photonz-Errortrak.ogg"], ["87 Droptek Colossus.zip", -2.0, "Colossus", "Monstercat", "Droptek", "Droptek_Colossus.ogg"], ["126 GingyandBordello BodyAcid.zip", 1.5, "Body Acid", "Turbo Recordings", "Gingy & Bordello", "Gingy&Bordello BodyAcid.ogg"], ["122 Amnesia Ibiza.zip", 1.0, "Ibiza", "Now Discs", "Amnesia", "Amnesia_Ibiza.ogg"], ["127 Granit Polar.zip", 0.0, "Polar", "JFX LAB", "GraniT", "Granit_Polar.ogg"], ["130 TheTown TheMovement.zip", 0.0, "The Movement", "ClekClekBoom", "The Town", "TheTown TheMovement.ogg"], ["118 Mondkopf Deadwood.zip", 0.0, "Deadwood", "In Paradisum", "Mondkopf", "Mondkopf_Deadwood.ogg"], ["131,7 DJPC ControlExpansion.zip", 4.0, "Control Expansion (DJPC Mix)", "Now Discs", "DJPC", "DJPC-ControlExpansion.ogg"], ["151,7 Feadz Metaman.zip", 1.5, "Metaman", "Ed Banger", "DJ Feadz", "Feadz-METAMAN.ogg"], ["118 DrafDodger M57.zip", -0.5, "M-57", "Midnight Trouble", "Draft Dodger", "mastered Go To The Moon.ogg"], ["128 FrenchFries BugNoticed.zip", 1.5, "Bug Noticed", "ClekClekBoom", "French Fries", "FrenchFries_BugNoticed.ogg"], ["127 Brodinski Oblivion.zip", -2.0, "Oblivion (Noob remix)", "Turbo Recordings", "Brodinski", "Brodinski_Oblivion(NoobRemix).ogg"], ["102 Oliver LightYearsAway.zip", -1.0, "Light Years Away", "Fool\'s Gold Records", "Oliver", "Oliver - Light Years Away (Instrumental).ogg"], ["125,94 PleasureGame AcrossTheDark.zip", 4.0, "Across the Dark", "Now Discs", "Pleasure Game", "PleasureGame Across the Dark.ogg"], ["128 JeanNipon Rosso.zip", -1.0, "Rosso", "Midnight Munchies", "Jean Nipon", "JeanNipon_ROSSO.ogg"]]');
}

/*
    Unfortunately, the only way to get CAudioSourceMusic to load (which are .zips)
    is if they are directly in `GameData/`.
    Being inside an outer zip and UiInstallFids() does not work (crash).
    Also can't get them to load from the user folder.

    // const string MEDIA_SOUNDS_TURBO = "file:///" + IO::FromUserGameFolder("Media/Sounds/Turbo/").Replace("\\", "/");
    // const string MEDIA_SOUNDS_TURBO = "file:///" + IO::FromUserGameFolder("Media/Sounds/Turbo/").Replace("\\", "/").SubStr(3);
    // const string MEDIA_SOUNDS_TURBO = IO::FromUserGameFolder("Media/Sounds/Turbo/").Replace("\\", "/");
    // const string MEDIA_SOUNDS_TURBO = "file:///Users/XertroV/Documents/Trackmania/Media/Sounds/Turbo/";
*/
const string MEDIA_SOUNDS_TURBO = "file://Media/Sounds/Turbo/";

const CAudioScriptMusic::EUpdateMode TurboMusicUpdateMode = CAudioScriptMusic::EUpdateMode::OnNextHalfBar;

const float C_VMAX = 10.;

bool _hasInitializedFids = false;

bool InitializeMusicFids() {
    _hasInitializedFids = true;
    if (_hasInitializedFids) return true;
    // auto zipFile = Fids::GetUser("TurboMusic.zip");
    // if (zipFile is null) {
    //     warn("Could not find TurboMusic.zip");
    //     return false;
    // }
    // CPlugFileZip@ zipNod = cast<CPlugFileZip>(Fids::Preload(zipFile));
    // if (zipNod !is null) {
    //     zipNod.MwAddRef();
    //     // zipNod.UiInstallFids();
    //     zipNod.UiInstallFidsInSubFolder();
    //     return true;
    // } else {
    //     warn("Could not preload TurboMusic.zip");
    // }
    return false;
}

namespace TurboConst {
    const string SoundFinishLine = "130 Finish Line.ogg";

    const string SoundStartLine = "starting.ogg";
    const string SoundStartLine2 = "starting2.ogg";
    string GetSoundStartLine() {
        switch (Math::Rand(0, 2)) {
            case 0: return SoundStartLine;
            case 1: return SoundStartLine2;
        }
        return SoundStartLine;
    }
    // const string SoundStartLine = "130 Start.ogg";

    const string MusicStandBy0 = "110 Pit Stop Twang - Military Loop1.ogg";
    const string MusicStandBy1 = "110 Pit Stop Twang - Military Loop2.ogg";
    const string MusicStandBy2 = "110 Pit Stop Twang - Military Loop3.ogg";
    const string MusicReplay = "MusicReplay.ogg";

    string GetMusicStandBy() {
        switch (Math::Rand(0, 3)) {
            case 0: return MusicStandBy0;
            case 1: return MusicStandBy1;
            case 2: return MusicStandBy2;
        }
        return MusicStandBy0;
    }

    const string SoundGameStart = "110 Pit Stop Military BONGO END NOTE For Random.ogg";

    // append number + .ogg
    const string SoundCheckpointFast = "130 Checkpoint Fast ";
    const string SoundCheckpointFast0 = "130 Checkpoint Fast 1.ogg";
    const string SoundCheckpointFast1 = "130 Checkpoint Fast 2.ogg";
    const string SoundCheckpointFast2 = "130 Checkpoint Fast 3.ogg";
    const string SoundCheckpointFast3 = "130 Checkpoint Fast 4.ogg";
    const string SoundCheckpointFast4 = "130 Checkpoint Fast 5.ogg";
    const string SoundCheckpointFast5 = "130 Checkpoint Fast 6.ogg";
    const string SoundCheckpointFast6 = "130 Checkpoint Fast 7.ogg";
    const string SoundCheckpointFast7 = "130 Checkpoint Fast 8.ogg";

    string GetSoundCheckpointFast(int i) {
        switch (i % 8) {
            case 0: return SoundCheckpointFast0;
            case 1: return SoundCheckpointFast1;
            case 2: return SoundCheckpointFast2;
            case 3: return SoundCheckpointFast3;
            case 4: return SoundCheckpointFast4;
            case 5: return SoundCheckpointFast5;
            case 6: return SoundCheckpointFast6;
            case 7: return SoundCheckpointFast7;
        }
        return SoundCheckpointFast7;
    }

    // append number + .ogg
    const string SoundCheckpointSlow = "130 Checkpoint Slow ";
    const string SoundCheckpointSlow0 = "130 Checkpoint Slow 1.ogg";
    const string SoundCheckpointSlow1 = "130 Checkpoint Slow 2.ogg";
    const string SoundCheckpointSlow2 = "130 Checkpoint Slow 3.ogg";
    const string SoundCheckpointSlow3 = "130 Checkpoint Slow 4.ogg";
    const string SoundCheckpointSlow4 = "130 Checkpoint Slow 5.ogg";
    const string SoundCheckpointSlow5 = "130 Checkpoint Slow 6.ogg";
    const string SoundCheckpointSlow6 = "130 Checkpoint Slow 7.ogg";
    const string SoundCheckpointSlow7 = "130 Checkpoint Slow 8.ogg";

    string GetSoundCheckpointSlow(int i) {
        switch (i % 8) {
            case 0: return SoundCheckpointSlow0;
            case 1: return SoundCheckpointSlow1;
            case 2: return SoundCheckpointSlow2;
            case 3: return SoundCheckpointSlow3;
            case 4: return SoundCheckpointSlow4;
            case 5: return SoundCheckpointSlow5;
            case 6: return SoundCheckpointSlow6;
            case 7: return SoundCheckpointSlow7;
        }
        return SoundCheckpointSlow7;
    }

    const string MusicMenuSimple = "110 Pit Stop Twang - Original - Edit 1 Oct 2015.ogg";
    const string MusicMenuSimple2 = "TMT_MENU_B1.ogg";

    string GetMusicMenuSimple() {
        switch (Math::Rand(0, 2)) {
            case 0: return MusicMenuSimple;
            case 1: return MusicMenuSimple2;
        }
        return MusicMenuSimple;
    }

    // for sound pack
    string[]@ GetSoundsFinishRace() {
        return {SoundFinishLine};
    }
    string[]@ GetSoundsFinishLap() { return {}; }
    string[]@ GetSoundsRespawn() { return {}; }
    string[]@ GetSoundsStartRace() { return {}; }

    string[]@ GetSoundsCheckpointFast() {
        return {
            SoundCheckpointFast0,
            SoundCheckpointFast1,
            SoundCheckpointFast2,
            SoundCheckpointFast3,
            SoundCheckpointFast4,
            SoundCheckpointFast5,
            SoundCheckpointFast6,
            SoundCheckpointFast7
        };
    }

    string[]@ GetSoundsCheckpointSlow() {
        return {
            SoundCheckpointSlow0,
            SoundCheckpointSlow1,
            SoundCheckpointSlow2,
            SoundCheckpointSlow3,
            SoundCheckpointSlow4,
            SoundCheckpointSlow5,
            SoundCheckpointSlow6,
            SoundCheckpointSlow7
        };
    }
}

Json::Value@ TurboMusicList = GetTurboMusicListJson();

namespace Turbo {
    void OnLeavePlayground() {
        CleanupInGameMusic();
    }

    void OnDestroyed() {
        OnLeavePlayground();
        CleanupMenuMusic();
    }

    void CleanupInGameMusic() {
        auto audio = cast<CTrackMania>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.Audio;
        // CleanupMusic(audio, G_Music);
        for (uint i = 0; i < G_MusicAll.Length; i++) {
            CleanupMusic(audio, G_MusicAll[i]);
            @G_MusicAll[i] = null;
        }
        G_MusicAll.Resize(0);
        CleanupSound(audio, G_MusicStandby);
        CleanupSound(audio, G_SoundStandbyEvent);
        CleanupSound(audio, G_MusicReplay);
        @G_MusicStandby = null;
        @G_SoundStandbyEvent = null;
        @G_MusicReplay = null;
        // cleaned up in G_MusicAll
        @G_Music = null;
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
            G_Music.VolumedB = -100.;
            G_Music.FadeDuration = 0.35;
            G_Music.FadeTracksDuration = G_Music.BeatDuration * 2;
            G_Music.Play();

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

    const float LPF_CUTOFF_RATIO_MIN = 0.42;

    void OnStartRace_Reset() {
        // G_Music.LPF_CutoffRatio = LPF_CUTOFF_RATIO_MIN;
        // G_Music.UpdateMode = TurboMusicUpdateMode;
        // G_Music.Dbg_ForceSequential = false;
        // G_Music.Dbg_ForceIntensity = false;
        // G_Music.Dbg_ForceRandom = false;
        // G_Music.EnableSegment("lap");
        // SetMusicLevel();
        // G_Music.Play();
        // trace("G_Music.Play() " + G_Music.IdName);
    }

    void SetMusicLevel() {
        {
            // if normal
            G_Music.VolumedB = (-8.5 - 1.0) * 0.0 + G_MusicGain;
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
            case VolumeCase::MusicIngame: { return vec3(0., 0.88, -24.); }
            case VolumeCase::MusicPause: { return vec3(0., 0.71, -21.); }
            case VolumeCase::MusicReplay: { return vec3(0., 0.71, -21.); }
            case VolumeCase::MusicStandby: { return vec3(0., 0.71, -21.); }
            case VolumeCase::MusicMenu: { return vec3(0., 1.,   -20.); }
            case VolumeCase::MusicIntro: { return vec3(0., 0.88, -14.); }
            case VolumeCase::MenuSFX: { return vec3(0., 0.35, -21.); }
            case VolumeCase::MenuAmbiance: { return vec3(0., 100., -21.); }
            case VolumeCase::MenuUISpreadLarge: { return vec3(0., 1.,   -14.); }
            case VolumeCase::MenuStartRace: { return vec3(0., 0.9,  -6.); }
            case VolumeCase::TransitionIngameChopper: { return vec3(0., 0.9,  -18.); }
            case VolumeCase::FinishLine: { return vec3(0., 0.7,  -20.); }
            case VolumeCase::StateFlying: { return vec3(0., 0.88, -100.); }
            case VolumeCase::SpeedEffectStart: { return vec3(0., 0.4, -16.); }
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
        if (sound == "MusicReplay") return 2.0; // GetMusicsVolume(-7.);
        if (sound == "MusicStandBy") return 2.0; // GetMusicsVolume(-2.);
        if (sound == "MusicBoosted") return 4.6;
        return -1.;
    }

    enum ERaceState {
        BeforeStart, Running, Finished, Eliminated, EndRound
    }

    void SetSFXSceneLevel() {
        // ignore this; touches Audio.LimitSceneSoundVolumedB
    }

    void ResetSounds(bool _ResetStandby) {
        if (_ResetStandby) G_MusicStandby.Stop();
        if (_ResetStandby) G_MusicReplay.Stop();
        if (G_Music !is null) {
            G_Music.Stop();
            G_Music.VolumedB = -100.;
        }
    }

    bool playgroundIsNull = true;
    bool playgroundWasNull = true;

    void Main() {
        warn("turbo music exiting immediately");
        return;
        startnew(Main_WatchPlaygroundLoop);
        startnew(Main_WatchMenuLoop);
        startnew(Main_WatchEditorLoop);
    }

    bool wasInMenu = false;
    bool isInMenu = false;

    void Main_WatchMenuLoop() {
        auto app = GetApp();
        while (true) {
            isInMenu = app.Switcher.ModuleStack.Length == 1 && cast<CTrackManiaMenus>(app.Switcher.ModuleStack[0]) !is null;
            if (isInMenu && !wasInMenu) {
                OnEnterMenu();
            } else if (!isInMenu && wasInMenu) {
                // OnLeaveMenu();
            }
            wasInMenu = isInMenu;
            yield();
        }
    }

    bool wasInEditor = false;
    bool isInEditor = false;

    void Main_WatchEditorLoop() {
        auto app = GetApp();
        while (true) {
            isInEditor = app.Editor !is null && app.CurrentPlayground is null; //  app.Switcher.ModuleStack.Length == 1 && cast<CTrackManiaEditor>(app.Switcher.ModuleStack[0]) !is null;
            if (isInEditor && !wasInEditor) {
                // OnEnterEditor();
            } else if (!isInEditor && wasInEditor) {
                // OnLeaveEditor();
            }
            wasInEditor = isInEditor;
            yield();
        }
    }

    void Main_WatchPlaygroundLoop() {
        auto app = GetApp();
        while (true) {
            playgroundIsNull = app.CurrentPlayground is null;
            if (playgroundIsNull && !playgroundWasNull) {
                // OnLeavePlayground();
            } else if (!playgroundIsNull && playgroundWasNull) {
                startnew(Main_CurrPlaygroundNotNull);
            }
            playgroundWasNull = playgroundIsNull;
            yield();
        }
    }

    void Main_CurrPlaygroundNotNull() {
        warn("Main_CurrPlaygroundNotNull");
        InitializeMusicFids();
        // audio.LimitSceneSoundVolumedB = Volumes::GetVolumedB("MainSFX");
        G_MusicDescs.RemoveRange(0, G_MusicDescs.Length);
        InitRandomMusicIndicies();
        PreloadSounds();
        auto app = GetApp();
        while (app.CurrentPlayground !is null) {
            OnRaceStateUpdate(GetCurrentRaceState());
            yield();
        }
        CleanupInGameMusic();
        warn("Main_CurrPlaygroundNotNull: end");
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

    CSmPlayer@ GetCurrentPlayer(CGameCtnApp@ app) {
        try { return cast<CSmPlayer>(app.CurrentPlayground.GameTerminals[0].ControlledPlayer); }
        catch { return null; }
    }

    ERaceState GetCurrentRaceState() {
        try {
            auto app = GetApp();
            if (app.CurrentPlayground is null) return ERaceState::BeforeStart;
            auto gt = app.CurrentPlayground.GameTerminals[0];
            if (gt.UISequence_Current == SGamePlaygroundUIConfig::EUISequence::EndRound) return ERaceState::EndRound;
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
        auto audio = GetAudio();

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
                    // m_isLastFinished = false;
                    break;
                case ERaceState::Finished:
                    m_raceStateTrigger_Finished = GameTime;
                    // Audio.LimitSceneSoundVolumedB = {{{Volumes::GetVolumedB("MainSFX")-12.}}};
                    m_isLastFinished = true;
                    break;
                case ERaceState::EndRound:
                    m_StartStandbyNeeded = true;
                    break;
            }
        }



        // net standby event
        // net replay event
        // net stop music event
        if (m_StartStandbyNeeded) {
            m_StartStandbyNeeded = false;
            G_Music.Stop();
            G_MusicReplay.Stop();
            G_MusicStandby.VolumedB = GetVolumedB("MusicStandBy");
            G_MusicStandby.Play();
            // Audio.LimitMusicVolumedB = 0.;
        }

        if (m_StartReplayNeeded) {
            m_StartReplayNeeded = false;
            G_Music.Stop();
            G_MusicStandby.Stop();
            G_MusicReplay.VolumedB = GetVolumedB("MusicReplay");
            G_MusicReplay.Play();
            // Audio.LimitSceneSoundVolumedB 	= {{{Volumes::GetVolumedB("MainSFXReplay")}}};
            // Audio.LimitMusicVolumedB = 0.;
        }

        if (m_StopMusicNeeded) {
            m_StopMusicNeeded = false;
            if (G_MusicStandby.IsPlaying && G_SoundStandbyEvent !is null) {
                trace("Music: Standby event");
                audio.PlaySoundEvent(G_SoundStandbyEvent, GetVolumedB("MusicReplay"));
            }
            G_Music.Stop();
            G_MusicStandby.Stop();
            G_MusicReplay.Stop();
            // SetSFXSceneLevel();
            // M_SplitscreenMusicLaunched = False;
        }

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

        Update_LPF(currSpeed);
    }

    void Update_LPF(float currSpeed) {
        float TargetLPFratioFromSpeed = LPF_CUTOFF_RATIO_MIN;
        float MinValue = LPF_CUTOFF_RATIO_MIN;

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

        bool isPaused = InGameMenuDisplayed || m_isLastFinished;
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
                float duration = G_Music.BeatDuration * 5.;
                float time = 1. * (GameTime - m_raceStateTrigger_Finished) / 1000.;
                SetMusicLevel();
                G_Debug_LastTargetLPFratioFromSpeed = easeOutCircle(time, max, -max + LPF_CUTOFF_RATIO_MIN, duration);
                G_Music.LPF_CutoffRatio = G_Debug_LastTargetLPFratioFromSpeed;
                // trace("Finish fade out: LPF: " + G_Music.LPF_CutoffRatio + " -> " + G_Debug_LastTargetLPFratioFromSpeed + " ( " + time + " / " + duration + "; m_raceStateTrigger_Finished: " + m_raceStateTrigger_Finished + "; GameTime: " + GameTime + ")");
            } else {
                G_Music.LPF_CutoffRatio = G_Debug_LastTargetLPFratioFromSpeed = LPF_CUTOFF_RATIO_MIN + 0.1;
            }
        }
    }

    int GameTime;
    bool InGameMenuDisplayed;


    // returns current speed
    float UpdateEngineOrWaypointEvents(ERaceState state, bool stateChanged = false) {
        // check engine
        // check waypoint
        // - if finish, end lap, or added CP
        auto app = GetApp();
        GameTime = app.Network.PlaygroundInterfaceScriptHandler.GameTime;
        InGameMenuDisplayed = app.Network.PlaygroundInterfaceScriptHandler.IsInGameMenuDisplayed;
        auto audio = cast<CTrackMania>(app).MenuManager.MenuCustom_CurrentManiaApp.Audio;
        auto player = GetCurrentPlayer(app);
        if (player is null) return 0.;

        auto playerScript = cast<CSmScriptPlayer>(player.ScriptAPI);
        playerCpIx = player.CurrentLaunchedRespawnLandmarkIndex;
        playerLapCount = playerScript.CurrentLapNumber;
        playerRespawned = playerScript.StartTime > GameTime;
        m_isLastFinished = app.CurrentPlayground.GameTerminals[0].UISequence_Current == SGamePlaygroundUIConfig::EUISequence::Finish;
        bool didFinish = !lastPlayerWasFinished && m_isLastFinished;
        if (playerCpIx != lastPlayerCpIx || didFinish) {
            if (m_isLastFinished && didFinish) {
                m_raceStateTrigger_Finished = GameTime;
                print("Playing finish line sound: " + TurboConst::SoundFinishLine);
                // end race?
                m_switchTrackNeeded = true;
                auto sound = audio.CreateSound(MEDIA_SOUNDS_TURBO + TurboConst::SoundFinishLine);
                if (sound is null) {
                    warn("Sound is null: " + TurboConst::SoundFinishLine);
                }
                // audio.PlaySoundEventMix(sound, 5.0, vec3());
                sound.VolumedB = 4.;
                sound.Play();
                startnew(SleepAndDestroy, sound);
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
        lastPlayerWasFinished = m_isLastFinished;


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
        // trying to get slowmo working but nope: * vis.AsyncState.SimulationTimeCoef;
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


    CAudioScriptSound@ G_MenuMusic;


    void OnEnterMenu() {
        auto audio = cast<CTrackMania>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.Audio;
        if (G_MenuMusic is null) {
            string menuTrack = TurboConst::GetMusicMenuSimple();
            @G_MenuMusic = audio.CreateSoundEx(MEDIA_SOUNDS_TURBO + menuTrack, 0.0, true, true, false);
            G_MenuMusic.PanRadiusLfe = GetMusicPanRadiusLfe(VolumeCase::MusicMenu);
            G_MenuMusic.VolumedB = menuTrack.Length < 20 ? 6. : 0.;
            G_MenuMusic.Play();
        }
    }

    void CleanupMenuMusic() {
        auto audio = cast<CTrackMania>(GetApp()).MenuManager.MenuCustom_CurrentManiaApp.Audio;
        if (G_MenuMusic !is null) {
            G_MenuMusic.Stop();
            audio.DestroySound(G_MenuMusic);
            @G_MenuMusic = null;
        }
    }
}
