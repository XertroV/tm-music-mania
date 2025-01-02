const string TM_TURBO_AP_NAME = "TM Turbo Music";
const string MP4_AP_NAME = "MP4 Music";
const string OLD_TM_AP_NAME = "Old TM Games' Music";
const string WII_AP_NAME = "Wii Music";
const string DS_AP_NAME = "DS Music";
const string VS_AP_NAME = "Virtual Skipper Music";

namespace DLC {
    bool get_gotTurbo() { return DoWeHaveAssetPack(TM_TURBO_AP_NAME); }
    bool get_gotMp4() { return DoWeHaveAssetPack(MP4_AP_NAME); }
    bool get_gotOld() { return DoWeHaveAssetPack(OLD_TM_AP_NAME); }
    bool get_gotWii() { return DoWeHaveAssetPack(WII_AP_NAME); }
    bool get_gotDs() { return DoWeHaveAssetPack(DS_AP_NAME); }
    bool get_gotVS() { return DoWeHaveAssetPack(VS_AP_NAME); }

    bool IsAnyAvailable() {
        return !(GotAllDownloadableAPs() && gotTurbo && gotMp4 && gotOld && gotWii && gotDs && gotVS);
    }

    void RenderDownloadMenu() {
        if (!gotTurbo) RenderDLCDownloader(turboAssetDownloader, TM_TURBO_AP_NAME, EnsureTurboAssets, "TM Turbo Music and Game Sounds. These should download automatically.");
        if (!gotMp4) RenderDLCDownloader(mp4AssetDownloader, MP4_AP_NAME, DownloadAllMp4Assets, "Music from Canyon, Lagoon, Stadium, Valley, and SM Storm.");
        if (!gotOld) RenderDLCDownloader(oldAssetDownloader, OLD_TM_AP_NAME, DownloadAllOldTmAssets, "Music from TMO, TMS, TMU, TMN ESWC, and TMNF.");
        if (!gotWii) RenderDLCDownloader(wiiAssetDownloader, WII_AP_NAME, DownloadAllWiiAssets, "Music from Trackmania Wii.");
        if (!gotDs) RenderDLCDownloader(dsAssetDownloader, DS_AP_NAME, DownloadAllDsAssets, "Music from TrackMania DS & TrackMania Turbo (DS).");
        if (!gotVS) RenderDLCDownloader(vsAssetDownloader, VS_AP_NAME, DownloadAllVSAssets, "Music from the Virtual Skipper series (mostly VS1).");
        for (uint i = 0; i < AP_Downloadables.Length; i++) {
            auto @dlc = AP_Downloadables[i];
            if (!dlc.HasRegisteredAssetPack()) {
                dlc.RenderDlcDownloader();
            }
        }
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
