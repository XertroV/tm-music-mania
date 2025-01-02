
const string AssetBase_DestDir = IO::FromAppFolder("GameData/Media/Sounds/");

const int MAX_CONCURRENT_DOWNLOADS = 10;

dictionary _DownloadedAssetPacks;

bool DoWeHaveAssetPack(const string &in name) {
    return _DownloadedAssetPacks.Exists(name);
}

void SetGotAssetPack(const string &in name) {
    _DownloadedAssetPacks[name] = true;
}


class AssetDownloader {
    string name;
    string destDirRaw;

    AssetDownloader(const string &in name, const string &in baseUrl, const string &in destDirRaw) {
        this.name = name;
        _BaseUrl = baseUrl;
        if (!destDirRaw.EndsWith("/")) {
            throw("destDirRaw must end with /");
        }
        this.destDirRaw = destDirRaw;
        _DestDir = IO::FromAppFolder(destDirRaw);
        if (!IO::FolderExists(_DestDir)) {
            IO::CreateFolder(_DestDir, true);
        }
    }

    private int _DlSemaphore = 0;
    private int _TotalDownloadsStarted = 0;
    private int _TotalDownloadsDone = 0;
    private string _BaseUrl;
    private string _DestDir;

    int get_TotalDownloadsStarted() {
        return _TotalDownloadsStarted;
    }
    int get_TotalDownloadsDone() {
        return _TotalDownloadsDone;
    }
    float get_DownloadsPctDone() {
        return float(_TotalDownloadsDone) / float(_TotalDownloadsStarted) * 100.0;
    }
    string get_DownloadsDoneOverStarted() {
        return tostring(_TotalDownloadsDone) + " / " + _TotalDownloadsStarted;
    }

    bool get_IsDone() {
        return _TotalDownloadsDone == _TotalDownloadsStarted;
    }

    Meta::PluginCoroutine@ DownloadAsset_InBg(const string &in asset) {
        return startnew(CoroutineFuncUserdataString(this.DownloadAsset), asset);
    }

    void DownloadAsset(const string &in asset) {
        _TotalDownloadsStarted++;
        while (_DlSemaphore >= MAX_CONCURRENT_DOWNLOADS) yield();
        _DlSemaphore++;
        string url = (_BaseUrl + asset).Replace(" ", "%20");
        string dest = _DestDir + asset;
        try {

            if (IO::FileExists(dest)) {
                dev_trace("Skipping download of " + asset + " as it already exists at " + dest);
                _DlSemaphore--;
                _TotalDownloadsDone++;
                return;
            }

            if (asset.Contains("/")) {
                CreateSubfoldersForAsset(asset);
            }

            trace("Downloading <" + asset + "> from " + url);

            Net::HttpRequest@ req = Net::HttpGet(url);
            while (!req.Finished()) yield();
            if (req.ResponseCode() != 200) {
                NotifyWarning("Failed (code="+req.ResponseCode()+") to download " + asset + " from " + url + " | error: " + req.Error() + " | response: " + req.String() + " | dest: " + dest);
            } else {
                req.SaveToFile(dest);
                trace("Downloaded " + asset + " to " + dest);
            }
        } catch {
            NotifyError("Failed to download " + asset + " / exception: " + getExceptionInfo() + " | dest: " + dest);
        }
        _DlSemaphore--;
        _TotalDownloadsDone++;
    }

    void CreateSubfoldersForAsset(const string &in asset) {
        string subfolder = asset.SubStr(0, asset.LastIndexOf("/"));
        string fullSubfolder = _DestDir + subfolder;
        if (!IO::FolderExists(fullSubfolder)) {
            IO::CreateFolder(fullSubfolder, true);
        }
    }

    void AwaitDownloadAllAssets() {
        yield(3);
        if (_DlSemaphore == 0) return;
        Notify("["+name+"] Waiting for " + _TotalDownloadsStarted + " assets to download...");
        int nextUpdate = Math::Max(2, _TotalDownloadsStarted / 5);
        while (_TotalDownloadsDone < _TotalDownloadsStarted) {
            while (_TotalDownloadsDone < nextUpdate && _TotalDownloadsDone < _TotalDownloadsStarted) yield();
            Notify("["+name+"] Downloads " + Text::Format("%02.1f%%", DownloadsPctDone) + " done ( " + _TotalDownloadsDone + " / " + _TotalDownloadsStarted + " )");
            nextUpdate += Math::Max(2, _TotalDownloadsStarted / 5);
        }
        while (_DlSemaphore > 0) yield();
        NotifySuccess("["+name+"] Downloaded " + _TotalDownloadsDone + " assets.");
    }
}
