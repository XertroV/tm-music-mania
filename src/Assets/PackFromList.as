AP_Downloadable@ AP_BigBang1112 = AP_Downloadable("BigBang1112 Remixes", "GameData/Media/Sounds/BigBang1112/", "https://assets.xk.io/OtherTmMusic/BigBang1112/",
"TMU/TMF Remixes by BigBang1112", """
TMF Menu Remix.ogg
TMU Bay Remix.ogg
TMU Coast Remix.ogg
TMU Desert Remix ft ThaumicTom.ogg
TMU Island Remix.ogg
TMU Rally Remix.ogg
TMU Snow Remix.ogg
""");

AP_Downloadable@ AP_ZaiLoop = AP_DownloadableLoop("Zai's Loop", "GameData/Media/Sounds/ZaiLoop/", "https://assets.xk.io/OtherTmMusic/ZaiLoop/", "Zai's in-game Loop", """
InThePast_L.zip
""");


AP_Downloadable@[] AP_Downloadables = {
    AP_BigBang1112
    // add more here
    // , AP_Blah
#if DEV
    , AP_ZaiLoop
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
