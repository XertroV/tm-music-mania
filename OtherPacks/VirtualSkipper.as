const string VS_Assets_BaseUrl = "https://assets.xk.io/OtherTmMusic/VS/";
const string VS_Assets_RawBaseDir = "GameData/Media/Sounds/VS/";
const string VS_Assets_BaseDir = IO::FromAppFolder("GameData/Media/Sounds/VS/");

const string MEDIA_SOUNDS_VS = "file://Media/Sounds/VS/";

string[] vs1Files;
string[] vsOtherFiles;

const string VS_AssetFiles = """
VS1/02 Track 02.ogg
VS1/03 Track 03.ogg
VS1/04 Track 04.ogg
VS1/05 Track 05.ogg
VS1/06 Track 06.ogg
VS1/07 Track 07.ogg
VS1/08 Track 08.ogg
VS1/09 Track 09.ogg
VS1/10 Track 10.ogg
VS1/11 Track 11.ogg
VS1/12 Track 12.ogg
VS1/13 Track 13.ogg
VS1/14 Track 14.ogg
VS1/15 Track 15.ogg
VS1/16 Track 16.ogg
VS1/17 Track 17.ogg
VS1/18 Track 18.ogg
VS1/source.txt
VS_Misc/VS3/GameSounds/CheckPoint.wav
VS_Misc/VS3/GameSounds/Lose.wav
VS_Misc/VS3/GameSounds/Start.wav
VS_Misc/VS3/GameSounds/VictoryGold.wav
VS_Misc/VS3/intro-vsk3.ogg
VS_Misc/VS4/Artbleek - London highs.ogg
VS_Misc/VS4/Mouton.wav
VS_Misc/VS4/nightclub.wav
VS_Misc/VS4/salsa.wav
VS_Misc/VS5/Credits.ogg
""";

string[]@ _vsAssetFiles = VSAssets_FilterOnlyMusicFiles(VS_AssetFiles.Split("\n"));

string[]@ VSAssets_FilterOnlyMusicFiles(string[]@ assetFiles) {
    string[]@ result = {};
    for (uint i = 0; i < assetFiles.Length; i++) {
        string asset = assetFiles[i];
        if (asset.Length < 2) continue;
        if (!asset.EndsWith(".ogg") && !asset.EndsWith(".wav")) continue;
        result.InsertLast(asset);

        if (asset.StartsWith("VS1/")) {
            vs1Files.InsertLast(asset.SubStr(4));
        } else {
            vsOtherFiles.InsertLast(asset.SubStr(8));
        }
    }
    return result;
}

AssetDownloader@ vsAssetDownloader = AssetDownloader(VS_AP_NAME, VS_Assets_BaseUrl, VS_Assets_RawBaseDir);

void DownloadAllVSAssets() {
    auto @filesInDir = IO_IndexFolderTrimmed(VS_Assets_BaseDir, true);
    for (uint i = 0; i < _vsAssetFiles.Length; i++) {
        if (filesInDir.Find(_vsAssetFiles[i]) != -1) {
            trace("Skipping download of " + _vsAssetFiles[i] + " as it already exists");
            continue;
        }
        vsAssetDownloader.DownloadAsset_InBg(_vsAssetFiles[i]);
        yield();
    }
    vsAssetDownloader.AwaitDownloadAllAssets();
    CheckVSAssetsAndRegister();
}

void CheckVSAssetsAndRegister() {
    if (!IO::FolderExists(VS_Assets_BaseDir)) {
        warn("VirtualSkipper folder does not exist: " + VS_Assets_BaseDir);
        return;
    }
    bool gotAll = true;
    gotAll = CheckVSAssetsSubfolderAndRegister("VS1", vs1Files) && gotAll;
    gotAll = CheckVSAssetsSubfolderAndRegister("VS_Misc", vsOtherFiles) && gotAll;
    if (gotAll) {
        SetGotAssetPack(VS_AP_NAME);
    }
}

bool CheckVSAssetsSubfolderAndRegister(const string &in subfolder, string[]@ files) {
    string subDir = VS_Assets_BaseDir + subfolder + "/";
    if (!IO::FolderExists(subDir)) {
        warn("VirtualSkipper subfolder does not exist: " + subDir);
        return false;
    }
    auto @filesInDir = IO_IndexFolderTrimmed(subDir, true);
    for (uint i = 0; i < files.Length; i++) {
        if (filesInDir.Find(files[i]) == -1) {
            warn("VirtualSkipper file missing: " + subDir + files[i]);
            return false;
        }
    }
    Packs::AddPack(AudioPack_Playlist(subfolder, MEDIA_SOUNDS_VS + subfolder + "/", files, 0.0));
    return true;
}
