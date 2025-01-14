// AP_Downloadable@ AP_TM2020_Extra = AP_DownloadableTM2020Extra("TM 2020 Seasonal Menu", "GameData/Media/Musics/Stadium/", "https://assets.xk.io/OtherTmMusic/TM2020/", "TM 2020 seasonal menu music.", "Menu-Fall.ogg\nMenu-Spring.ogg\nMenu-Summer.ogg\nMenu-Winter.ogg");

// AP_Downloadable@ AP_BigBang1112 = AP_Downloadable("BigBang1112 Remixes", "GameData/Media/Sounds/BigBang1112/", "https://assets.xk.io/OtherTmMusic/BigBang1112/", "TMU/TMF Remixes by BigBang1112", "Bay (Realnest Bootleg).ogg\nCoast (Realnest Bootleg).ogg\nDesert (Realnest & ThaumicTom Bootleg).ogg\nDoo - Menus (Realnest Bootleg).ogg\nIsland (Realnest Bootleg).ogg\nRally (Realnest Bootleg).ogg\nSnow (Realnest Bootleg).ogg"); // TMF Menu Remix.ogg\nTMU Bay Remix.ogg\nTMU Coast Remix.ogg\nTMU Desert Remix ft ThaumicTom.ogg\nTMU Island Remix.ogg\nTMU Rally Remix.ogg\nTMU Snow Remix.ogg

// AP_Downloadable@ AP_ZaiLoop = AP_DownloadableLoop("BigBang1112 + Zai's Loops", "GameData/Media/Sounds/ZaiLoop/", "https://assets.xk.io/OtherTmMusic/ZaiLoop/", "Zai's conversion of some BigBang1112 tracks into in-game Music Loops", "InThePast_L.zip\nGrown_L.zip\nTheseTimes_L.zip");

// AP_Downloadable@ AP_PMC = AP_Downloadable("Project Minecraft", "GameData/Media/Sounds/PMC/", "https://assets.xk.io/MusicMisc/PMC/", "Project Minecraft", "Badlands.ogg\nBlossom.ogg\nCaves.ogg\nEnd.ogg\nJungle.ogg\nNether.ogg\nSwamp.ogg\nTundra.ogg");

// AP_Downloadable@ AP_ZaiLoop = AP_DownloadableLoop("ZaiLoop.json");
// AP_Downloadable@ AP_NeoCupra = AP_Downloadable("NeoCupra.json");
// AP_Downloadable@ AP_BigBang1112 = AP_Downloadable("BigBang1112.json");

// AP_Downloadable@ AP_Outer_Wilds = AP_Downloadable("Outer Wilds OST", "GameData/Media/Sounds/OuterWilds/", "https://assets.xk.io/MusicMisc/Outer Wilds/", "Music from Outer Wilds. (Great game. You should play it.)", "01. Timber Hearth.ogg\n02. Outer Wilds.ogg\n03. The Museum.ogg\n04. Space.ogg\n05. Castaways.ogg\n06. The Sun Station.ogg\n07. Main Title.ogg\n08. The Search.ogg\n09. The Uncertainty Principle.ogg\n10. End Times.ogg\n11. 22 Minutes.ogg\n12. The Nomai.ogg\n13. The Ash Twin Project.ogg\n14. Dark Bramble.ogg\n15. Giants Deep.ogg\n16. Nomai Ruins.ogg\n17. Final Voyage.ogg\n18. The Ancient Glade.ogg\n19. Curiosity.ogg\n20. Travelers.ogg\n21. Let There Be Light.ogg\n22. 14.3 Billion Years.ogg\n23. Morning.ogg\n24. Campfire Song.ogg\n25. Into the Wilds.ogg\n26. Arrow of Time.ogg\n27. We Have Liftoff.ogg\n28. A Terrible Fate.ogg");
// AP_Downloadable@ AP_FTL = AP_Downloadable("FTL OST", "GameData/Media/Sounds/FTL/", "https://assets.xk.io/MusicMisc/FLT/", "Music from FTL: Faster Than Light", "Ben Prunty - FTL - 01 Space Cruise (Title).ogg\nBen Prunty - FTL - 02 MilkyWay (Explore).ogg\nBen Prunty - FTL - 03 Civil (Explore).ogg\nBen Prunty - FTL - 04 Cosmos (Explore).ogg\nBen Prunty - FTL - 05 Deepspace (Explore).ogg\nBen Prunty - FTL - 06 Debris (Explore).ogg\nBen Prunty - FTL - 07 Mantis (Explore).ogg\nBen Prunty - FTL - 08 Engi (Explore).ogg\nBen Prunty - FTL - 09 Colonial (Explore).ogg\nBen Prunty - FTL - 10 Wasteland (Explore).ogg\nBen Prunty - FTL - 11 Rockmen (Explore).ogg\nBen Prunty - FTL - 12 Void (Explore).ogg\nBen Prunty - FTL - 13 Zoltan (Explore).ogg\nBen Prunty - FTL - 14 BONUS Federation.ogg\nBen Prunty - FTL - 15 MilkyWay (Battle).ogg\nBen Prunty - FTL - 16 Civil (Battle).ogg\nBen Prunty - FTL - 17 Cosmos (Battle).ogg\nBen Prunty - FTL - 18 Deepspace (Battle).ogg\nBen Prunty - FTL - 19 Debris (Battle).ogg\nBen Prunty - FTL - 20 Mantis (Battle).ogg\nBen Prunty - FTL - 21 Engi (Battle).ogg\nBen Prunty - FTL - 22 Colonial (Battle).ogg\nBen Prunty - FTL - 23 Wasteland (Battle).ogg\nBen Prunty - FTL - 24 Rockmen (Battle).ogg\nBen Prunty - FTL - 25 Void (Battle).ogg\nBen Prunty - FTL - 26 Zoltan (Battle).ogg\nBen Prunty - FTL - 27 Last Stand.ogg\nBen Prunty - FTL - 28 Victory.ogg\nBen Prunty - FTL - 29 BONUS Horror.ogg");

// commas go before entries to make commenting lines possible without breaking the last entry
AP_Downloadable@[] AP_Downloadables = {
    // AP_TM2020_Extra
    // , AP_NeoCupra
    // AP_BigBang1112
    // , AP_PMC
    // , AP_ZaiLoop
    // , AP_Outer_Wilds
    // add more here
#if DEV
    // , AP_ZaiLoop
#endif
};

const int REGEX_FLAGS = Regex::Flags::ECMAScript;

bool GotAllDownloadableAPs() {
    for (uint i = 0; i < AP_Downloadables.Length; i++) {
        // if we do not have AP, return false
        if (!AP_Downloadables[i].HasRegisteredAssetPack()) {
            return false;
        }
    }
    return true;
}

void ValidateFileName_OptDir_IsSafe(const string &in fileName) {
    ValidateFileName_IsRelativeNoDots(fileName);
}

void ValidateFileName_NoDir_IsSafe(const string &in fileName) {
    ValidateFileName_NoDirectory(fileName);
    ValidateFileName_IsRelativeNoDots(fileName);
}

void ValidateFileName_NoDirectory(const string &in fileName) {
    if (fileName.Contains("/")) throw("Invalid JSON file name (contains `/`): `" + fileName + "`");
    if (fileName.Contains("\\")) throw("Invalid JSON file name (contains `\\`): `" + fileName + "`");
}

void ValidateFileName_IsRelativeNoDots(const string &in fileName) {
    if (fileName.Contains("..")) throw("Invalid JSON file name (contains `..`): `" + fileName + "`");
    if (fileName.Contains(":")) throw("Invalid JSON file name (contains `:`): `" + fileName + "`");
}

namespace PackDownloadable {
    const string JsonPackDir = IO::FromStorageFolder("Packs/");
    string[] FailedToParse;

    void Init() {
        if (!IO::FolderExists(JsonPackDir)) {
            IO::CreateFolder(JsonPackDir, true);
        }
        CheckLoadJsonPack("ZaiLoop.json");
        CheckLoadJsonPack("BigBang1112.json");

        yield();
        RefreshDir();
    }

    dictionary LoadedFiles;

    void RefreshDir() {
        auto savedFiles = IO_IndexFolderTrimmed(JsonPackDir, false);
        for (uint i = 0; i < savedFiles.Length; i++) {
            string fileName = savedFiles[i];
            if (!fileName.EndsWith(".json")) continue;

            if (LoadedFiles.Exists(fileName)) continue;

            trace("Loading AssetPack from JSON: " + fileName);
#if DEV || RAISE_EXCEPTIONS
            auto packs = LoadPacksFromJson(fileName);
            LoadedFiles[fileName] = true;
            for (uint j = 0; j < packs.Length; j++) {
                AP_Downloadables.InsertLast(packs[j]);
            }
#else
            try {
                auto packs = LoadPacksFromJson(fileName);
                LoadedFiles[fileName] = true;

                for (uint j = 0; j < packs.Length; j++) {
                    AP_Downloadables.InsertLast(packs[j]);
                }
                if ((i+1) % 5 == 0) yield();
            } catch {
                NotifyError("Failed to load AssetPack from JSON: " + fileName);
                NotifyError(getExceptionInfo());
                FailedToParse.InsertLast(fileName);
            }
#endif
        }
    }

    Json::Value@ CheckLoadJsonPack(const string &in jsonFileName) {
        ValidateFileName_NoDir_IsSafe(jsonFileName);
        if (!IO::FileExists(JsonPackDir + jsonFileName)) {
            try {
                IO::FileSource f("Packs/" + jsonFileName);
                string jsonStr = f.ReadToEnd();
                if (jsonStr.Length == 0) throw("Empty JSON file");
                IO::File file(JsonPackDir + jsonFileName, IO::FileMode::Write);
                file.Write(jsonStr);
                return Json::Parse(jsonStr);
            } catch {}
            throw("AssetPack JSON file does not exist: " + jsonFileName);
        }
        return Json::FromFile(JsonPackDir + jsonFileName);
    }

    AP_Downloadable@[]@ LoadPacksFromJson(const string &in jsonFile) {
        auto j = CheckLoadJsonPack(jsonFile);
        return LoadPacksFromJson(j);
    }

    AP_Downloadable@[]@ LoadPacksFromJson(const Json::Value@ j) {
        string name = j["name"];
        string baseDir = j["baseDir"];
        string baseUrl = j.Get("baseUrl", "");
        string description = j["desc"];
        dev_trace("name, baseDir, description, baseUrl: " + name + ", " + baseDir + ", " + description + ", " + baseUrl + ", ");

        string trackFilter = j.Get("trackFilter", "");
        string fileFilter = j.Get("fileFilter", "");
        dev_trace("trackFilter, fileFilter: " + trackFilter + ", " + fileFilter);

        // Json::Value@ filesJ = cast<Json::Value>(cast<ref>(j.Get("files", Json::Value())));
        const Json::Value@ filesJ = j.Get("files", Json::Parse("null"));
        const Json::Value@ tracksJ = j.Get("tracks", Json::Parse("null"));
        const Json::Value@ subListsJ = j.Get("subLists", Json::Parse("null"));
        const Json::Value@ gameSoundsJ = j.Get("gameSounds", Json::Parse("null"));
        const Json::Value@ turboStyleMusicList = Validate_TurboStyleMusicList(j.Get("turboStyleMusicList", Json::Parse("null")));

        bool loops = j.Get("loops", false);
        bool hasTurboGameSounds = j.Get("hasTurboGameSounds", false);
        bool trimDirsAfterDl = j.Get("trimDirsAfterDl", false);

        // -- Validation --

        // base dir
        ValidateFileName_OptDir_IsSafe(baseDir);
        if (baseDir.StartsWith("/")) throw("baseDir must not start with `/`");
        if (baseDir.EndsWith("/")) throw("baseDir must not end with `/`");
        if (!baseDir.StartsWith("Music") && !baseDir.StartsWith("Sounds")) throw("baseDir must start with `Music` or `Sounds`");
        baseDir = "GameData/Media/" + baseDir + "/";
        // files/tracks - the only other source of file names
        string[]@ files = Validate_JsonFiles("files", filesJ, fileFilter);
        string[]@ tracks = Validate_JsonFiles("tracks", tracksJ, trackFilter);

        PackSubList@[]@ subLists = Validate_SubLists(subListsJ);
        PackGameSounds@[]@ gameSounds = Validate_GameSounds(gameSoundsJ);

        // -- End Validation --
        // check flags and requirements
        if (loops && (files is null || files.Length == 0)) throw("loops=true but no `files` provided");
        if (!loops && files !is null) throw("loops=true but `files` were provided");
        if (hasTurboGameSounds && gameSounds !is null) throw("hasTurboGameSounds=true but `gameSounds` also present");

        // -- Create AssetPack --

        AP_Downloadable@[] ret;

        if (files !is null) {
            ret.InsertLast(AP_DownloadableLoop(name + " (Loops)", baseDir, baseUrl, description, string::Join(files, "\n")).WithLoopsExtra(fileFilter, turboStyleMusicList));
        }
        if (tracks !is null) {
            ret.InsertLast(AP_Downloadable(name, baseDir, baseUrl, description, string::Join(tracks, "\n")).WithJsonExtra(
                trackFilter, subLists, gameSounds, hasTurboGameSounds, trimDirsAfterDl
            ));
        }
        // if (gameSounds !is null) {
        //     ret.InsertLast(AP_Downloadable_GameSounds(name, baseDir, baseUrl, description, gameSounds, hasTurboGameSounds));
        // }

        return ret;
    }

    string[]@ Validate_JsonFiles(const string &in listName, const Json::Value@ j, const string &in fileFilter) {
        if (j.GetType() == Json::Type::Null) return null;
        if (j.GetType() != Json::Type::Array) throw("Expected array of files for `"+listName+"`, got " + tostring(j.GetType()));
        string[] ret;
        for (uint i = 0; i < j.Length; i++) {
            string fileName = string(j[i]);
            ValidateFileName_OptDir_IsSafe(fileName);
            ret.InsertLast(fileName);
        }
        if (ret.Length == 0) {
            if (j.Length > 0) warn("No files found for " + listName + " after filtering using pattern `"+fileFilter+"`");
            return null;
        }
        return ret;
    }

    PackSubList@[]@ Validate_SubLists(const Json::Value@ j) {
        if (j.GetType() == Json::Type::Null) return null;
        if (j.GetType() != Json::Type::Object) throw("Expected object of sublists, got " + tostring(j.GetType()));
        PackSubList@[] ret;
        auto keys = j.GetKeys();
        for (uint i = 0; i < keys.Length; i++) {
            string name = keys[i];
            ret.InsertLast(PackSubList(name, j[name]));
        }
        if (ret.Length == 0) return null;
        return ret;
    }

    PackGameSounds@[]@ Validate_GameSounds(const Json::Value@ j) {
        if (j.GetType() == Json::Type::Null) return null;
        if (j.GetType() != Json::Type::Object) throw("Expected object of game sounds, got " + tostring(j.GetType()));
        PackGameSounds@[] ret;
        auto keys = j.GetKeys();
        for (uint i = 0; i < keys.Length; i++) {
            string name = keys[i];
            ret.InsertLast(PackGameSounds(name, j[name]));
        }
        if (ret.Length == 0) return null;
        return ret;
    }

    const Json::Value@ Validate_TurboStyleMusicList(const Json::Value@ j) {
        if (j.GetType() == Json::Type::Null) return null;
        if (j.GetType() != Json::Type::Array) throw("Expected array of turbo-style music list, got " + tostring(j.GetType()));
        if (j.Length == 0) return null;
        if (j[0].GetType() != Json::Type::Array) throw("Expected array of [string, float, string?, string?, string?] for turbo-style music list, for [0], got " + tostring(j[0].GetType()) + " (should have been Array)");
        if (j[0][0].GetType() != Json::Type::String) throw("Expected array of [string, float, string?, string?, string?] for turbo-style music list, for [0][0] got " + tostring(j[0].GetType()) + " (should have been String)");
        if (j[0][1].GetType() != Json::Type::Number) throw("Expected array of [string, float, string?, string?, string?] for turbo-style music list, for [0][1] got " + tostring(j[0].GetType()) + " (should have been Number)");
        return j;
    }



    class PackSubList {
        string name;
        string regex;
        // other sublists, we exclude files from this sublist if they're in any of those other ones.
        string[]@ notIn;

        PackSubList(const string &in name, const Json::Value@ j) {
            this.name = name;
            if (j.GetType() == Json::Type::String) {
                regex = string(j);
                @notIn = {};
            } else if (j.GetType() == Json::Type::Object) {
                regex = j["regex"];
                const Json::Value@ notInJ = j.Get("not-in", Json::Array());
                @notIn = Json_ToStringArray(notInJ);
            }
        }
    }

    class PackGameSounds {
        string name;
        string regex;

        PackGameSounds(const string &in name, const Json::Value@ j) {
            this.name = name;
            if (j.GetType() == Json::Type::String) {
                regex = string(j);
            } else {
                regex = j["regex"];
            }
        }
    }
}


string[]@ Json_ToStringArray(const Json::Value@ j) {
    string[] ret;
    for (uint i = 0; i < j.Length; i++) {
        ret.InsertLast(string(j[i]));
    }
    return ret;
}


class AP_Downloadable {
    string name;
    string baseDir;
    string mediaUriBase;
    string baseUrl;
    string[]@ files;
    string description;
    string concreteBaseDir;
    bool AllFilesDownloaded = false;
    AssetDownloader@ Downloader;

    // from json, optional
    PackDownloadable::PackSubList@[]@ subLists;
    PackDownloadable::PackGameSounds@[]@ gameSounds;
    bool hasTurboGameSounds = false;
    bool trimDirsAfterDl = false;
    string trackFilter;
    // for loops
    string fileFilter;
    const Json::Value@ turboStyleMusicList;



    AP_Downloadable(const string &in name, const string &in baseDir, const string &in baseUrl, const string &in description, const string &in files) {
        this.name = name;
        ValidateFileName_OptDir_IsSafe(baseDir);
        this.baseDir = baseDir;
        if (baseDir.Contains(":/") || !baseDir.StartsWith("GameData/")) {
            throw("baseDir must be relative to app folder & start with GameData/. Instead, got " + baseDir);
        }
        mediaUriBase = "file://" + baseDir.SubStr(9);
        this.baseUrl = baseUrl;
        this.description = description;
        @this.files = FilterSounds({".ogg", ".wav", ".zip", ".mux"}, files.Split("\n"));
        concreteBaseDir = IO::FromAppFolder(baseDir);
        @Downloader = AssetDownloader(name, baseUrl, baseDir);
        startnew(CoroutineFunc(CheckAssetsAndRegister_SlightDelay));
    }

    void CheckAssetsAndRegister_SlightDelay() {
        yield(3);
        CheckAssetsAndRegister();
    }

    void CheckAssetsAndRegister() {
        if (!IO::FolderExists(concreteBaseDir)) {
            warn("AssetPack folder does not exist: " + baseDir);
            return;
        }
        // todo: support multiple lists or w/e; like with `gotAll = CheckDsAssetsSubfolderAndRegister("DS", dsFiles) && gotAll`

        bool gotAll = true;
        auto @filesInDir = IO_IndexFolderTrimmed(concreteBaseDir, true);
        for (uint i = 0; i < files.Length; i++) {
            if (filesInDir.Find(ProcessOutputNameAfterDl(files[i])) == -1) {
                // warn("AssetPack file missing: " + concreteBaseDir + files[i]);
                gotAll = false;
            }
        }
        if (gotAll) {
            SetGotAssetPack(name);
            AddMainAssetPack();
        }
    }

    protected void AddMainAssetPack() {
        auto pack = CreatePlaylistWithFilteredTracks();
        if (subLists !is null && subLists.Length > 0) pack.WithSubLists(subLists);
        if (hasTurboGameSounds || (gameSounds !is null && gameSounds.Length > 0)) AddGameSoundPacks(gameSounds, hasTurboGameSounds);
        Packs::AddPack(pack);
    }

    AudioPack_Playlist@ CreatePlaylistWithFilteredTracks() {
        auto @_files = files;
        if (trimDirsAfterDl) {
            @_files = {};
            for (uint i = 0; i < files.Length; i++) {
                _files.InsertLast(ProcessOutputNameAfterDl(files[i]));
            }
        }

        if (trackFilter.Length == 0) return AudioPack_Playlist(name, mediaUriBase, _files, 0.0);

        string[] ts;
        for (uint i = 0; i < _files.Length; i++) {
            string file = _files[i];
            if (Regex::Contains(file, trackFilter, REGEX_FLAGS)) {
                ts.InsertLast(file);
            }
        }
        return AudioPack_Playlist(name, mediaUriBase, ts, 0.0);
    }


    protected void AddGameSoundPacks(PackDownloadable::PackGameSounds@[]@ gameSounds, bool hasTurboGameSounds) {
        // todo
        if (Time::Stamp > 1736897331) throw("Implement AddGameSoundPacks");
    }

    bool HasRegisteredAssetPack() {
        return DoWeHaveAssetPack(name);
    }

    void RenderDlcDownloader() {
        DLC::RenderDLCDownloader(this.Downloader, this.name, CoroutineFunc(this.DownloadAllAssets), description);
    }

    void DownloadAllAssets() {
        auto @filesInDir = IO_IndexFolderTrimmed(concreteBaseDir, true);
        for (uint i = 0; i < files.Length; i++) {
            if (filesInDir.Find(ProcessOutputNameAfterDl(files[i])) != -1) {
                trace("Skipping download of " + files[i] + " as it already exists");
                continue;
            }
            Downloader.DownloadAsset_InBg(files[i]);
            // add one per frame to space things out, avoid hangs or w/e
            yield();
        }
        Downloader.AwaitDownloadAllAssets();
        CheckAssetsAndRegister();
    }

    AP_Downloadable@ WithJsonExtra(const string &in trackFilter, PackDownloadable::PackSubList@[]@ subLists, PackDownloadable::PackGameSounds@[]@ gameSounds, bool hasTurboGameSounds, bool trimDirsAfterDl) {
        this.trackFilter = trackFilter;
        @this.subLists = subLists;
        @this.gameSounds = gameSounds;
        this.hasTurboGameSounds = hasTurboGameSounds;
        this.trimDirsAfterDl = trimDirsAfterDl;
        this.Downloader.trimDirsAfterDl = trimDirsAfterDl;
        return this;
    }

    string ProcessOutputNameAfterDl(const string &in fileName) {
        if (trimDirsAfterDl) {
            return Path::GetFileName(fileName);
            // return fileName.SubStr(fileName.LastIndexOf("/") + 1);
        }
        return fileName;
    }
}

// class AP_DownloadableTM2020Extra : AP_Downloadable {
//     AP_DownloadableTM2020Extra(const string &in name, const string &in baseDir, const string &in baseUrl, const string &in description, const string &in files) {
//         super(name, baseDir, baseUrl, description, files);
//     }

//     protected void AddMainAssetPack() override {
//         for (uint i = 0; i < files.Length; i++) {
//             AP_Tm2020_Playlist.AddTrack(Playlist_Track(files[i]));
//         }
//         AP_Downloadable::AddMainAssetPack();
//     }
// }

class AP_DownloadableLoop : AP_Downloadable {
    AP_DownloadableLoop(const string &in name, const string &in baseDir, const string &in baseUrl, const string &in description, const string &in files) {
        super(name, baseDir, baseUrl, description, files);
    }

    protected void AddMainAssetPack() override {
        auto j = Json::Array();
        for (uint i = 0; i < files.Length; i++) {
            j.Add(_FileToLoopJsonArr(files[i]));
        }
        Packs::AddPack(AudioPack_LoopsTurbo(name, mediaUriBase, j));
    }

    AP_DownloadableLoop@ WithLoopsExtra(const string &in fileFilter, const Json::Value@ turboStyleMusicList) {
        this.fileFilter = fileFilter;
        if (turboStyleMusicList !is null && turboStyleMusicList.GetType() == Json::Type::Array) {
            @this.turboStyleMusicList = turboStyleMusicList;
        }
        return this;
    }
}

Json::Value@ _FileToLoopJsonArr(const string &in file) {
    // example: ["120 Breakbot ShadesOfBlack.zip", 1.5, "Shades of Black", "Ed Banger", "Breakbot", "Breakbot-Shades of black.ogg"]
    auto j = Json::Array();
    j.Add(file);
    j.Add(0.0); // gain
    j.Add(file.SubStr(0, file.Length - 4)); // name
    // can skip the rest, but they would be label, artist, sample
    return j;
}

string[]@ FilterSounds(array<string>@ extensions, string[]@ files) {
    array<string> filteredFiles;
    filteredFiles.Reserve(files.Length);
    for (uint i = 0; i < files.Length; i++) {
        if (files[i].Length < 2) continue;
        if (!FileEndsWithAny(files[i], extensions)) continue;
        filteredFiles.InsertLast(files[i]);
        // trace("Filtered: " + file);
    }
    return filteredFiles;
}

bool FileEndsWithAny(const string &in file, array<string>@ extensions) {
    for (uint i = 0; i < extensions.Length; i++) {
        if (file.EndsWith(extensions[i])) {
            return true;
        }
    }
    return false;
}
