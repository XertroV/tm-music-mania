const string Mp4Assets_BaseUrl = "https://assets.xk.io/Mp4Music/";
const string Mp4Assets_RawBaseDir = "GameData/Media/Sounds/Mp4/";
const string Mp4Assets_BaseDir = IO::FromAppFolder(Mp4Assets_RawBaseDir);

const string MEDIA_SOUNDS_MP4 = "file://Media/Sounds/Mp4/";

string[] smStormFiles;
string[] canyonFiles;
string[] lagoonFiles;
string[] valleyFiles;
string[] stadiumFiles;
string[] mp4RaceAnyFiles; // tm2: in-game
string[] mp4MenuFiles; // menus
string[] mp4AnyFiles; // in-game only

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

; menu musics
Menu/MP_EnterTitle.ogg
Menu/MP_Main.ogg
Menu/MP_MainLoop.ogg
Menu/MP_StationLoop.ogg
Menu/canyon_menu.ogg
Menu/lagoon_menu.ogg
Menu/stadium_menu.ogg
Menu/valley_menu.ogg
Menu/sm_menu.ogg

; online but not downloaded (filtered in Mp4Assets_FilterOnlyMusicFiles)
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
        if (assetFiles[i].StartsWith(";")) continue;
        if (assetFiles[i].EndsWith(".zip")) continue;
        string file = assetFiles[i];
        filteredFiles.InsertLast(file);
        // trace("Filtered: " + file);

        if (file.StartsWith("SMStorm/")) {
            smStormFiles.InsertLast(file.SubStr(8));
            mp4AnyFiles.InsertLast(file);
        } else if (file.StartsWith("Canyon/")) {
            canyonFiles.InsertLast(file.SubStr(7));
            mp4AnyFiles.InsertLast(file);
            mp4RaceAnyFiles.InsertLast(file);
        } else if (file.StartsWith("Lagoon/")) {
            lagoonFiles.InsertLast(file.SubStr(7));
            mp4AnyFiles.InsertLast(file);
            mp4RaceAnyFiles.InsertLast(file);
        } else if (file.StartsWith("Valley/")) {
            valleyFiles.InsertLast(file.SubStr(7));
            mp4AnyFiles.InsertLast(file);
            mp4RaceAnyFiles.InsertLast(file);
        } else if (file.StartsWith("Stadium/")) {
            stadiumFiles.InsertLast(file.SubStr(8));
            mp4AnyFiles.InsertLast(file);
            mp4RaceAnyFiles.InsertLast(file);
        } else if (file.StartsWith("Menu/")) {
            mp4MenuFiles.InsertLast(file.SubStr(5));
        }
    }
    return filteredFiles;
}

AssetDownloader@ mp4AssetDownloader = AssetDownloader(MP4_AP_NAME, Mp4Assets_BaseUrl, Mp4Assets_RawBaseDir);

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
    gotAll = CheckMp4AssetsSubfolderAndRegister("", mp4AnyFiles, "MP4: In-Game Any") && gotAll;
    gotAll = CheckMp4AssetsSubfolderAndRegister("Menu", mp4MenuFiles, "MP4: Menus") && gotAll;
    gotAll = CheckMp4AssetsSubfolderAndRegister("", mp4RaceAnyFiles, "TM²: Any") && gotAll;
    gotAll = CheckMp4AssetsSubfolderAndRegister("SMStorm", smStormFiles, "ShootMania Storm") && gotAll;
    gotAll = CheckMp4AssetsSubfolderAndRegister("Canyon", canyonFiles, "TM²: Canyon") && gotAll;
    gotAll = CheckMp4AssetsSubfolderAndRegister("Lagoon", lagoonFiles, "TM²: Lagoon") && gotAll;
    gotAll = CheckMp4AssetsSubfolderAndRegister("Stadium", stadiumFiles, "TM²: Stadium") && gotAll;
    gotAll = CheckMp4AssetsSubfolderAndRegister("Valley", valleyFiles, "TM²: Valley") && gotAll;
    if (gotAll) {
        SetGotAssetPack(MP4_AP_NAME);
    }
}

bool CheckMp4AssetsSubfolderAndRegister(const string &in subfolder, string[]@ files, const string &in nameInsteadOfSubfolder = "") {
    if (subfolder.Length == 0 && nameInsteadOfSubfolder.Length == 0) {
        throw("CheckMp4AssetsSubfolderAndRegister: subfolder and nameInsteadOfSubfolder are both empty");
    }
    // c:/.../GameData/Media/Sounds/Mp4/<subfolder>/
    string subfolderDir = Mp4Assets_BaseDir + (subfolder.Length > 0 ? subfolder + "/" : "");

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
    RegisterMp4AssetPack(subfolder, files, nameInsteadOfSubfolder);
    return true;
}

void RegisterMp4AssetPack(const string &in subfolder, string[]@ files, const string &in nameInsteadOfSubfolder = "") {
    if (nameInsteadOfSubfolder.Length == 0 && subfolder.Length == 0) {
        throw("RegisterMp4AssetPack: nameInsteadOfSubfolder and subfolder are both empty");
    }
    auto baseDir = MEDIA_SOUNDS_MP4 + (subfolder.Length > 0 ? subfolder + "/" : "");
    trace("Registering Mp4AssetPack: " + subfolder);
    string apName = nameInsteadOfSubfolder.Length > 0 ? nameInsteadOfSubfolder : subfolder;
    Packs::AddPack(AudioPack_Playlist(apName, baseDir, files, 0.0));
}
