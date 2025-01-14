namespace DLC {
    int MissingDLCPacks() {
        int missing = 0;
        for (uint i = 0; i < AP_Downloadables.Length; i++) {
            auto @dlc = AP_Downloadables[i];
            if (!dlc.HasRegisteredAssetPack()) {
                missing++;
            }
        }
        return missing;
    }

    bool IsAnyAvailable() {
        // return !( && gotTurbo && gotMp4 && gotOld && gotWii && gotDs && gotVS);
        return !GotAllDownloadableAPs();
    }

    void RenderDownloadMenu(bool renderIfMissing = true) {
        for (uint i = 0; i < AP_Downloadables.Length; i++) {
            auto @dlc = AP_Downloadables[i];
            if (renderIfMissing ^^ dlc.HasRegisteredAssetPack()) {
                dlc.RenderDlcDownloader();
            }
        }
    }

    void RenderDLCDownloader(AssetDownloader@ downloader, const string &in packName, CoroutineFunc@ downloadFn, const string &in description) {
        bool alreadyDownloaded = DoWeHaveAssetPack(packName);
        bool downloading = !downloader.IsDone;
        bool disabled = downloading || alreadyDownloaded;

        UI::BeginDisabled(disabled);

        UI::Indent(12.0);
        if (UX::SmallButton(Icons::Download + " " + packName)) {
            startnew(downloadFn);
        }
        if (alreadyDownloaded) {
            UI::SameLine();
            UI::Text("\\$<\\$4b4" + Icons::Check + "\\$> Downloaded");
        }

        UI::TextWrapped("\\$i\\$bbb" + description);
        UI::Unindent(12.0);

        if (!downloader.IsDone) {
            UI::Text("Downloaded: " + downloader.DownloadsDoneOverStarted + " (" + downloader.DownloadsPctDone + " %)");
        }

        UI::Separator();

        UI::EndDisabled();
    }
}
