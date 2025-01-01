const string DsAssets_BaseUrl = "https://assets.xk.io/OtherTmMusic/";
const string DsAssets_RawBaseDir = "GameData/Media/Sounds/";
const string DsAssets_BaseDir = IO::FromAppFolder("GameData/Media/Sounds/");

const string MEDIA_SOUNDS_DS = "file://Media/Sounds/";

string[] dsFiles;
string[] dsTurboFiles;

const string DsAssetFiles = """
DS_Turbo/01 Frontend Music.ogg
DS_Turbo/02 Coast Music.ogg
DS_Turbo/03 Island Music.ogg
DS_Turbo/04 Snow Music.ogg
DS_Turbo/05 Stadium Music.ogg
DS/01_Menu.ogg
DS/02_Desert.ogg
DS/03_Rally.ogg
DS/04_Stadium.ogg
""";

string[]@ _dsAssetFiles = DsAssets_FilterOnlyMusicFiles(DsAssetFiles.Split("\n"));

string[]@ DsAssets_FilterOnlyMusicFiles(string[]@ assetFiles) {
    string[]@ result = {};
    for (uint i = 0; i < assetFiles.Length; i++) {
        string asset = assetFiles[i];
        if (asset.Length < 2) continue;
        if (!asset.EndsWith(".ogg")) continue;
        result.InsertLast(asset);

        if (asset.Contains("DS_Turbo")) {
            dsTurboFiles.InsertLast(asset.SubStr(9));
        } else {
            dsFiles.InsertLast(asset.SubStr(3));
        }
    }
    return result;
}

AssetDownloader@ dsAssetDownloader = AssetDownloader("DsAssets", DsAssets_BaseUrl, DsAssets_RawBaseDir);

void DownloadAllDsAssets() {
    auto @filesInDir = IO_IndexFolderTrimmed(DsAssets_BaseDir, true);
    for (uint i = 0; i < _dsAssetFiles.Length; i++) {
        if (filesInDir.Find(_dsAssetFiles[i]) != -1) {
            trace("Skipping download of " + _dsAssetFiles[i] + " as it already exists");
            continue;
        }
        dsAssetDownloader.DownloadAsset_InBg(_dsAssetFiles[i]);
        yield();
    }
    dsAssetDownloader.AwaitDownloadAllAssets();
    CheckDsAssetsAndRegister();
}

void CheckDsAssetsAndRegister() {
    if (!IO::FolderExists(DsAssets_BaseDir)) {
        warn("DsAssets folder does not exist: " + DsAssets_BaseDir);
        return;
    }
    bool gotAll = true;
    gotAll = CheckDsAssetsSubfolderAndRegister("DS", dsFiles) && gotAll;
    gotAll = CheckDsAssetsSubfolderAndRegister("DS_Turbo", dsTurboFiles) && gotAll;
    if (gotAll) {
        SetGotAssetPack("DsAssets");
    }
}

bool CheckDsAssetsSubfolderAndRegister(const string &in subfolder, string[]@ files) {
    string subDir = DsAssets_BaseDir + subfolder + "/";
    if (!IO::FolderExists(subDir)) {
        warn("DsAssets subfolder does not exist: " + subDir);
        return false;
    }
    auto @filesInDir = IO_IndexFolderTrimmed(subDir, true);
    for (uint i = 0; i < files.Length; i++) {
        if (filesInDir.Find(files[i]) == -1) {
            warn("DsAssets file missing: " + subfolder + "/" + files[i]);
            return false;
        }
    }
    RegisterDsAssetPack(subfolder, files);
    return true;
}

void RegisterDsAssetPack(const string &in subfolder, string[]@ files) {
    trace("Registering DS Asset Pack: " + subfolder);
    Packs::AddPack(AudioPack_Playlist(subfolder, MEDIA_SOUNDS_DS + subfolder + "/", files, 0.0));
}
