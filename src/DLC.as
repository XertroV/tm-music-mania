namespace DLC {
    bool get_gotTurbo() { return DoWeHaveAssetPack("TurboAssets"); }
    bool get_gotMp4() { return DoWeHaveAssetPack("Mp4Assets"); }
    bool get_gotOld() { return DoWeHaveAssetPack("OldTmAssets"); }

    bool IsAnyAvailable() {
        return !(gotTurbo && gotMp4 && gotOld);
    }

    void RenderDownloadMenu() {
        if (!gotTurbo) RenderDLCDownloader(turboAssetDownloader, "TurboAssets", EnsureTurboAssets, "TM Turbo Music and Game Sounds. These should download automatically.");
        if (!gotMp4) RenderDLCDownloader(mp4AssetDownloader, "Mp4Assets", DownloadAllMp4Assets, "Music from Canyon, Lagoon, Stadium, Valley, and SM Storm.");
        if (!gotOld) RenderDLCDownloader(oldAssetDownloader, "OldTmAssets", DownloadAllOldTmAssets, "Music from TMO, TMS, TMU, TMN ESWC, and TMNF.");
    }

    void RenderDLCDownloader(AssetDownloader@ downloader, const string &in packName, CoroutineFunc@ downloadFn, const string &in description) {
        bool disabled = !downloader.IsDone || DoWeHaveAssetPack(packName);
        UI::BeginDisabled(disabled);

        UI::Indent(12.0);
        if (UX::SmallButton(Icons::Download + " " + packName)) {
            startnew(downloadFn);
        }

        UI::TextWrapped("\\$i\\$bbb" + description);
        UI::Unindent(12.0);

        if (disabled) {
            UI::Text("Downloaded: " + downloader.DownloadsDoneOverStarted + " (" + downloader.DownloadsPctDone + " %)");
        }
        UI::Separator();

        UI::EndDisabled();
    }
}
