AP_Downloadable@ AP_TM2020_Extra = AP_DownloadableTM2020Extra("TM 2020 Seasonal Menu", "GameData/Media/Musics/Stadium/", "https://assets.xk.io/OtherTmMusic/TM2020/", "TM 2020 seasonal menu music.", "Menu-Fall.ogg\nMenu-Spring.ogg\nMenu-Summer.ogg\nMenu-Winter.ogg");

AP_Downloadable@ AP_BigBang1112 = AP_Downloadable("BigBang1112 Remixes", "GameData/Media/Sounds/BigBang1112/", "https://assets.xk.io/OtherTmMusic/BigBang1112/", "TMU/TMF Remixes by BigBang1112", "Bay (Realnest Bootleg).ogg\nCoast (Realnest Bootleg).ogg\nDesert (Realnest & ThaumicTom Bootleg).ogg\nDoo - Menus (Realnest Bootleg).ogg\nIsland (Realnest Bootleg).ogg\nRally (Realnest Bootleg).ogg\nSnow (Realnest Bootleg).ogg"); // TMF Menu Remix.ogg\nTMU Bay Remix.ogg\nTMU Coast Remix.ogg\nTMU Desert Remix ft ThaumicTom.ogg\nTMU Island Remix.ogg\nTMU Rally Remix.ogg\nTMU Snow Remix.ogg

AP_Downloadable@ AP_ZaiLoop = AP_DownloadableLoop("BigBang1112 + Zai's Loops", "GameData/Media/Sounds/ZaiLoop/", "https://assets.xk.io/OtherTmMusic/ZaiLoop/", "Zai's conversion of some BigBang1112 tracks into in-game Music Loops", "InThePast_L.zip\nGrown_L.zip\nTheseTimes_L.zip");

AP_Downloadable@ AP_PMC = AP_Downloadable("Project Minecraft", "GameData/Media/Sounds/PMC/", "https://assets.xk.io/MusicMisc/PMC/", "Project Minecraft", "Badlands.ogg\nBlossom.ogg\nCaves.ogg\nEnd.ogg\nJungle.ogg\nNether.ogg\nSwamp.ogg\nTundra.ogg");

AP_Downloadable@ AP_Outer_Wilds = AP_Downloadable("Outer Wilds OST", "GameData/Media/Sounds/OuterWilds/", "https://assets.xk.io/MusicMisc/Outer Wilds/", "Music from Outer Wilds. (Great game. You should play it.)", "01. Timber Hearth.ogg\n02. Outer Wilds.ogg\n03. The Museum.ogg\n04. Space.ogg\n05. Castaways.ogg\n06. The Sun Station.ogg\n07. Main Title.ogg\n08. The Search.ogg\n09. The Uncertainty Principle.ogg\n10. End Times.ogg\n11. 22 Minutes.ogg\n12. The Nomai.ogg\n13. The Ash Twin Project.ogg\n14. Dark Bramble.ogg\n15. Giants Deep.ogg\n16. Nomai Ruins.ogg\n17. Final Voyage.ogg\n18. The Ancient Glade.ogg\n19. Curiosity.ogg\n20. Travelers.ogg\n21. Let There Be Light.ogg\n22. 14.3 Billion Years.ogg\n23. Morning.ogg\n24. Campfire Song.ogg\n25. Into the Wilds.ogg\n26. Arrow of Time.ogg\n27. We Have Liftoff.ogg\n28. A Terrible Fate.ogg");

// commas go before entries to make commenting lines possible without breaking the last entry
AP_Downloadable@[] AP_Downloadables = {
    AP_TM2020_Extra
    , AP_BigBang1112
    , AP_PMC
    , AP_Outer_Wilds
    , AP_ZaiLoop
    // add more here
#if DEV
    // , AP_ZaiLoop
#endif
};

bool GotAllDownloadableAPs() {
    for (uint i = 0; i < AP_Downloadables.Length; i++) {
        // if we do not have AP, return false
        if (!AP_Downloadables[i].HasRegisteredAssetPack()) {
            return false;
        }
    }
    return true;
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

    AP_Downloadable(const string &in name, const string &in baseDir, const string &in baseUrl, const string &in description, const string &in files) {
        this.name = name;
        this.baseDir = baseDir;
        if (baseDir.Contains(":/") || !baseDir.StartsWith("GameData/")) {
            throw("baseDir must be relative to app folder & start with GameData/. Instead, got " + baseDir);
        }
        mediaUriBase = "file://" + baseDir.SubStr(9);
        this.baseUrl = baseUrl;
        this.description = description;
        @this.files = FilterSounds({".ogg", ".wav", ".zip"}, files.Split("\n"));
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
            if (filesInDir.Find(files[i]) == -1) {
                warn("AssetPack file missing: " + concreteBaseDir + files[i]);
                gotAll = false;
            }
        }
        if (gotAll) {
            SetGotAssetPack(name);
            AddMainAssetPack();
        }
    }

    protected void AddMainAssetPack() {
        Packs::AddPack(AudioPack_Playlist(name, mediaUriBase, files, 0.0));
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
            if (filesInDir.Find(files[i]) != -1) {
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
}

class AP_DownloadableTM2020Extra : AP_Downloadable {
    AP_DownloadableTM2020Extra(const string &in name, const string &in baseDir, const string &in baseUrl, const string &in description, const string &in files) {
        super(name, baseDir, baseUrl, description, files);
    }

    protected void AddMainAssetPack() override {
        for (uint i = 0; i < files.Length; i++) {
            AP_Tm2020_Playlist.AddTrack(Playlist_Track(files[i]));
        }
        AP_Downloadable::AddMainAssetPack();
    }
}

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
