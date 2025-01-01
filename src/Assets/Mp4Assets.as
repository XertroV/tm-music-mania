const string Mp4Assets_BaseUrl = "https://assets.xk.io/Mp4Music/";
const string Mp4Assets_RawBaseDir = "GameData/Media/Sounds/Mp4/";
const string Mp4Assets_BaseDir = IO::FromAppFolder("GameData/Media/Sounds/Mp4/");

const string MEDIA_SOUNDS_MP4 = "file://Media/Sounds/Mp4/";

string[] smStormFiles;
string[] canyonFiles;
string[] lagoonFiles;
string[] valleyFiles;
string[] stadiumFiles;

// zip files exist online but will be skipped for download
const string Mp4AssetFiles = """
Canyon/Canyon1.ogg
Canyon/Canyon1b.ogg
Canyon/Canyon2.ogg
Canyon/Canyon2b.ogg
Canyon/Canyon3.ogg
Canyon/Canyon3b.ogg
Canyon/Canyon4.ogg
Canyon/Canyon4b.ogg

Lagoon/1. Sunset&Day - Thunder.ogg
Lagoon/2. Day - White Sands.ogg
Lagoon/3. Night - Nervous.ogg
Lagoon/4. Night - Tribe Diamond.ogg
Lagoon/5. Sunrise - Lucky Cat.ogg
Lagoon/6. Sunrise - Yenset.ogg
Lagoon/7. Sunset - Ridge Roller.ogg

SMStorm/DAY_01_Track_03.ogg
SMStorm/DAY_02_Track_04.ogg
SMStorm/DAY_03_Track_05.ogg
SMStorm/NIGHT_01_Track_06.ogg
SMStorm/NIGHT_02_Track_07.ogg

Stadium/Air Time.ogg
Stadium/Dashboard.ogg
Stadium/Hydroplane.ogg
Stadium/Tachmania.ogg
Stadium/Tail Lights.ogg

Valley/1. Sunrise - Forecast.ogg
Valley/2. Sunrise&Day - Orange.ogg
Valley/3. Day - Vast Veridian.ogg
Valley/4. Sunset - Perforated Landscape.ogg
Valley/5. Sunset - Setting.ogg
Valley/6. Night - Extra Cologne.ogg
Valley/7. Night - Ritual.ogg

TMValley_music.zip
TMLagoon_music.zip
SMStorm_music.zip
TMStadium_music.zip
""";

string[]@ _mp4AssetFiles = Mp4Assets_FilterOnlyMusicFiles(Mp4AssetFiles.Split("\n"));

string[]@ Mp4Assets_FilterOnlyMusicFiles(string[]@ assetFiles) {
    array<string> filteredFiles;
    for (uint i = 0; i < assetFiles.Length; i++) {
        if (assetFiles[i].Length < 2) continue;
        if (assetFiles[i].EndsWith(".zip")) continue;
        string file = assetFiles[i];
        filteredFiles.InsertLast(file);
        trace("Filtered: " + file);

        if (file.StartsWith("SMStorm/")) {
            smStormFiles.InsertLast(file.SubStr(8));
        } else if (file.StartsWith("Canyon/")) {
            canyonFiles.InsertLast(file.SubStr(7));
        } else if (file.StartsWith("Lagoon/")) {
            lagoonFiles.InsertLast(file.SubStr(7));
        } else if (file.StartsWith("Valley/")) {
            valleyFiles.InsertLast(file.SubStr(7));
        } else if (file.StartsWith("Stadium/")) {
            stadiumFiles.InsertLast(file.SubStr(8));
        }
    }
    return filteredFiles;
}

AssetDownloader@ mp4AssetDownloader = AssetDownloader("Mp4Assets", Mp4Assets_BaseUrl, Mp4Assets_RawBaseDir);

void DownloadAllMp4Assets() {
    auto @filesInDir = IO_IndexFolderTrimmed(Mp4Assets_BaseDir, true);
    for (uint i = 0; i < _mp4AssetFiles.Length; i++) {
        if (filesInDir.Find(_mp4AssetFiles[i]) != -1) {
            trace("Skipping download of " + _mp4AssetFiles[i] + " as it already exists");
            continue;
        }
        mp4AssetDownloader.DownloadAsset_InBg(_mp4AssetFiles[i]);
        yield();
    }
    mp4AssetDownloader.AwaitDownloadAllAssets();
    CheckMp4AssetsAndRegister();
}

void CheckMp4AssetsAndRegister() {
    if (!IO::FolderExists(Mp4Assets_BaseDir)) {
        warn("Mp4Assets folder does not exist: " + Mp4Assets_BaseDir);
        return;
    }
    bool gotAll = true;
    gotAll = CheckMp4AssetsSubfolderAndRegister("SMStorm", smStormFiles) && gotAll;
    gotAll = CheckMp4AssetsSubfolderAndRegister("Canyon", canyonFiles) && gotAll;
    gotAll = CheckMp4AssetsSubfolderAndRegister("Lagoon", lagoonFiles) && gotAll;
    gotAll = CheckMp4AssetsSubfolderAndRegister("Valley", valleyFiles) && gotAll;
    gotAll = CheckMp4AssetsSubfolderAndRegister("Stadium", stadiumFiles) && gotAll;
    if (gotAll) {
        SetGotAssetPack("Mp4Assets");
    }
}

bool CheckMp4AssetsSubfolderAndRegister(const string &in subfolder, string[]@ files) {
    // c:/.../GameData/Media/Sounds/Mp4/<subfolder>/
    string subfolderDir = Mp4Assets_BaseDir + subfolder + "/";
    if (!IO::FolderExists(subfolderDir)) {
        warn("Mp4AssetPack subfolder does not exist: " + subfolderDir);
        return false;
    }
    for (uint i = 0; i < files.Length; i++) {
        string file = files[i];
        if (!IO::FileExists(subfolderDir + file)) {
            warn("Mp4AssetPack file does not exist: " + subfolderDir + file);
            return false;
        }
    }
    RegisterMp4AssetPack(subfolder, files);
    return true;
}

void RegisterMp4AssetPack(const string &in subfolder, string[]@ files) {
    trace("Registering Mp4AssetPack: " + subfolder);
    Packs::AddPack(AudioPack_Playlist(subfolder, MEDIA_SOUNDS_MP4 + subfolder + "/", files, 0.0));
}
