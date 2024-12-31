
const string AssetBase_DestDir = IO::FromAppFolder("GameData/Media/Sounds/");

const int MAX_CONCURRENT_DOWNLOADS = 20;
int _AssetDlSemaphore = 0;
int _TotalDownloadsStarted = 0;
int _TotalDownloadsDone = 0;

void DownloadAsset(const string &in baseUrl, const string &in destDir, const string &in asset) {
	_TotalDownloadsStarted++;
	while (_AssetDlSemaphore >= MAX_CONCURRENT_DOWNLOADS) yield();
	_AssetDlSemaphore++;
	try {
		string url = baseUrl + asset.Replace(" ", "%20");
		string dest = destDir + asset;
		trace("Downloading <" + asset + "> from " + url);

		Net::HttpRequest@ req = Net::HttpGet(url);
		while (!req.Finished()) yield();
		if (req.ResponseCode() != 200) {
			NotifyWarning("Failed (code="+req.ResponseCode()+") to download " + asset + " from " + url + " | error: " + req.Error() + " | response: " + req.String());
		} else {
			req.SaveToFile(dest);
			trace("Downloaded " + asset + " to " + dest);
		}
	} catch {
		NotifyError("Failed to download " + asset + " / exception: " + getExceptionInfo());
	}
	_AssetDlSemaphore--;
	_TotalDownloadsDone++;
}

void AwaitDownloadAllAssets() {
	yield(3);
	if (_AssetDlSemaphore == 0) return;
	Notify("Waiting for " + _TotalDownloadsStarted + " assets to download...");
	while (_AssetDlSemaphore > 0) yield();
	NotifySuccess("Downloaded " + _TotalDownloadsDone + " assets.");
}
