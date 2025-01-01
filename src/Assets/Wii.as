const string WiiAssets_BaseUrl = "https://assets.xk.io/OtherTmMusic/Wii/";
const string WiiAssets_RawBaseDir = "GameData/Media/Sounds/Wii/";
const string WiiAssets_BaseDir = IO::FromAppFolder("GameData/Media/Sounds/Wii/");

const string MEDIA_SOUNDS_WII = "file://Media/Sounds/Wii/";

string[] wiiMiscFiles;
string[] wiiRaceFiles;
string[] wiiMenuFiles;
string[] wiiCoastFiles;
string[] wiiDesertFiles;
string[] wiiIslandFiles;
string[] wiiRallyFiles;
string[] wiiSnowFiles;
string[] wiiStadiumFiles;
// editor tracks are pretty lame. just wind
string[] wiiEditorFiles;

const string WiiAssetFiles = """
01_Intro.ogg
02_Menu.ogg
03_Coast 1.ogg
04_Coast 2.ogg
05_Coast Editor.ogg
06_Desert 1.ogg
07_Desert 2.ogg
08_Desert Editor.ogg
09_Island 1.ogg
10_Island 2.ogg
11_Island Editor.ogg
12_Rally 1.ogg
13_Rally 2.ogg
14_Rally Editor.ogg
15_Snow 1.ogg
16_Snow 2.ogg
17_Snow Editor.ogg
18_Stadium 1.ogg
19_Stadium 2.ogg
20_Stadium 3.ogg
21_Stadium Editor.ogg
22_DC.ogg
23_Polymorph.ogg
""";

string[]@ _wiiAssetFiles = WiiAssets_FilterOnlyMusicFiles(WiiAssetFiles.Split("\n"));

string[]@ WiiAssets_FilterOnlyMusicFiles(string[]@ assetFiles) {
    string[]@ result = {};
    for (uint i = 0; i < assetFiles.Length; i++) {
        string asset = assetFiles[i];
        if (asset.Length < 2) continue;
        if (!asset.EndsWith(".ogg")) continue;
        result.InsertLast(asset);

        if (asset.Contains("Editor")) {
            wiiEditorFiles.InsertLast(asset);
        } else if (asset.Contains("Stadium")) {
            wiiStadiumFiles.InsertLast(asset);
            wiiRaceFiles.InsertLast(asset);
        } else if (asset.Contains("Snow")) {
            wiiSnowFiles.InsertLast(asset);
            wiiRaceFiles.InsertLast(asset);
        } else if (asset.Contains("Rally")) {
            wiiRallyFiles.InsertLast(asset);
            wiiRaceFiles.InsertLast(asset);
        } else if (asset.Contains("Island")) {
            wiiIslandFiles.InsertLast(asset);
            wiiRaceFiles.InsertLast(asset);
        } else if (asset.Contains("Desert")) {
            wiiDesertFiles.InsertLast(asset);
            wiiRaceFiles.InsertLast(asset);
        } else if (asset.Contains("Coast")) {
            wiiCoastFiles.InsertLast(asset);
            wiiRaceFiles.InsertLast(asset);
        } else if (asset.StartsWith("0")) {
            wiiMenuFiles.InsertLast(asset);
        } else {
            wiiMiscFiles.InsertLast(asset);
        }
    }
    return result;
}

AssetDownloader@ wiiAssetDownloader = AssetDownloader("WiiAssets", WiiAssets_BaseUrl, WiiAssets_RawBaseDir);

void DownloadAllWiiAssets() {
    auto @filesInDir = IO_IndexFolderTrimmed(WiiAssets_BaseDir, true);
    for (uint i = 0; i < _wiiAssetFiles.Length; i++) {
        if (filesInDir.Find(_wiiAssetFiles[i]) != -1) {
            trace("Skipping download of " + _wiiAssetFiles[i] + " as it already exists");
            continue;
        }
        wiiAssetDownloader.DownloadAsset_InBg(_wiiAssetFiles[i]);
        yield();
    }
    wiiAssetDownloader.AwaitDownloadAllAssets();
    CheckWiiAssetsAndRegister();
}

void CheckWiiAssetsAndRegister() {
    if (!IO::FolderExists(WiiAssets_BaseDir)) {
        warn("WiiAssets folder does not exist: " + WiiAssets_BaseDir);
        return;
    }
    bool gotAll = true;
    gotAll = CheckWiiAssetsSubfolderAndRegister("Wii Menu", wiiMenuFiles) && gotAll;
    gotAll = CheckWiiAssetsSubfolderAndRegister("Wii Race (Any)", wiiRaceFiles) && gotAll;
    gotAll = CheckWiiAssetsSubfolderAndRegister("Wii Coast", wiiCoastFiles) && gotAll;
    gotAll = CheckWiiAssetsSubfolderAndRegister("Wii Desert", wiiDesertFiles) && gotAll;
    gotAll = CheckWiiAssetsSubfolderAndRegister("Wii Island", wiiIslandFiles) && gotAll;
    gotAll = CheckWiiAssetsSubfolderAndRegister("Wii Rally", wiiRallyFiles) && gotAll;
    gotAll = CheckWiiAssetsSubfolderAndRegister("Wii Snow", wiiSnowFiles) && gotAll;
    gotAll = CheckWiiAssetsSubfolderAndRegister("Wii Stadium", wiiStadiumFiles) && gotAll;
    gotAll = CheckWiiAssetsSubfolderAndRegister("Wii Editor", wiiEditorFiles) && gotAll;
    gotAll = CheckWiiAssetsSubfolderAndRegister("Wii Misc", wiiMiscFiles) && gotAll;
    if (gotAll) {
        SetGotAssetPack("WiiAssets");
    }
}

bool CheckWiiAssetsSubfolderAndRegister(const string &in name, string[]@ files) {
    if (!IO::FolderExists(WiiAssets_BaseDir)) {
        warn("WiiAssets subfolder does not exist: " + WiiAssets_BaseDir);
        return false;
    }
    for (uint i = 0; i < files.Length; i++) {
        if (files[i].Length < 2) continue;
        if (!IO::FileExists(WiiAssets_BaseDir + files[i])) {
            warn("WiiAssets file does not exist: " + WiiAssets_BaseDir + files[i]);
            return false;
        }
    }
    RegisterWiiAssetPack(name, files);
    return true;
}

void RegisterWiiAssetPack(const string &in name, string[]@ files) {
    trace("Registering Wii Asset Pack: " + name);
    Packs::AddPack(AudioPack_Playlist(name, MEDIA_SOUNDS_WII, files, 0.0));
}
