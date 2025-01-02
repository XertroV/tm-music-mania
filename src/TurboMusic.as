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
    const float LPF_CUTOFF_RATIO_MIN = 0.42;

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
}
