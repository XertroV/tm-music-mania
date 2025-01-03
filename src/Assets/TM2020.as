// fake these assets because they already exist
const string TM2020_RawBaseDir = "GameData/Media/Musics/Stadium/";
const string MEDIA_MUSICS_STADIUM = "file://Media/Musics/Stadium/";

const string TM2020_FilePaths = """
Editor/TrackEditor-Infusion.ogg
Race/Race 1 - Chassis.ogg
Race/Race 2 - Paradigm.ogg
Race/Race 3 - Vegas Grease.ogg
Race/Race 4 - No Invites to this Party.ogg
Race/Race 5 - Cardboard Mustang.ogg
Race/Race 6 - Duct Tape, Take the Wheel.ogg
Race/Race 7 - Welcome To The Club.ogg
Menu/MainMenu-Menu.ogg
Menu/MainMenu-Royal.ogg
Stunt/MainTheme.ogg
""";


AudioPack_Playlist@ AP_Tm2020_Playlist;

void Register_Tm2020_Assets() {
    SetGotAssetPack("TM2020");
    auto @files = TM2020_FilePaths.Split("\n");
    // filter in AudioPack_Playlist when passing string[]@
    // for (int i = int(files.Length) - 1; i >= 0; i--) {
    //     if (files[i].Length < 2) {
    //         files.RemoveAt(i);
    //     }
    // }
    @AP_Tm2020_Playlist = AudioPack_Playlist("TM 2020", MEDIA_MUSICS_STADIUM, files, 0.0);
    Packs::AddPack(AP_Tm2020_Playlist);
}
