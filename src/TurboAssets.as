const string Assets_BaseUrl = "https://assets.xk.io/TurboMusic/";
const string Assets_DestDir = IO::FromAppFolder("GameData/Media/Sounds/Turbo/");
string[]@ initialTurboAssetDirList;

void EnsureAssets() {
	if (!IO::FolderExists(Assets_DestDir)) {
		IO::CreateFolder(Assets_DestDir, true);
	}
	@initialTurboAssetDirList = IO::IndexFolder(Assets_DestDir, true);
	for (uint i = 0; i < initialTurboAssetDirList.Length; i++) {
		auto @parts = initialTurboAssetDirList[i].Split("/Media/Sounds/Turbo/");
		initialTurboAssetDirList[i] = parts[parts.Length - 1];
	}
	trace("initialTurboAssetDirList: " + Json::Write(initialTurboAssetDirList.ToJson()));
	QueueEnsureTurboAssetsDownloaded();
	AwaitDownloadAllAssets();
}

void QueueEnsureTurboAssetsDownloaded() {
	QueueEnsureTurboAsset("102 Oliver LightYearsAway.zip");
	QueueEnsureTurboAsset("104 BusyP RainbowMan.zip");
	QueueEnsureTurboAsset("110 Pit Stop Military BONGO END NOTE For Random.ogg");
	QueueEnsureTurboAsset("110 Pit Stop Twang - Military End Note.ogg");
	QueueEnsureTurboAsset("110 Pit Stop Twang - Military Loop1.ogg");
	QueueEnsureTurboAsset("110 Pit Stop Twang - Military Loop2.ogg");
	QueueEnsureTurboAsset("110 Pit Stop Twang - Military Loop3.ogg");
	QueueEnsureTurboAsset("110 Pit Stop Twang - Original - Edit 1 Oct 2015.ogg");
	QueueEnsureTurboAsset("110 Pit Stop Twang - Original Menu End Note.ogg");
	QueueEnsureTurboAsset("110 Pit Stop Twang - Replay Version End Note.ogg");
	QueueEnsureTurboAsset("118 DJ Pone ErroticImpulses.zip");
	QueueEnsureTurboAsset("118 DrafDodger M57.zip");
	QueueEnsureTurboAsset("118 Mondkopf Deadwood.zip");
	QueueEnsureTurboAsset("119 Costello Primal.zip");
	QueueEnsureTurboAsset("120 Breakbot ShadesOfBlack.zip");
	QueueEnsureTurboAsset("120 MitchMurder Breakazoid.zip");
	QueueEnsureTurboAsset("122 Amnesia Ibiza.zip");
	QueueEnsureTurboAsset("122 Mitch MurderBreeze.zip");
	QueueEnsureTurboAsset("124 4getMeNot ABroad.zip");
	QueueEnsureTurboAsset("125 Randomer NoHook.zip");
	QueueEnsureTurboAsset("125,94 PleasureGame AcrossTheDark.zip");
	QueueEnsureTurboAsset("126 Aethority DirtyJose.zip");
	QueueEnsureTurboAsset("126 Benoit B Traxxmen.zip");
	QueueEnsureTurboAsset("126 Don Rimini AdamandEve.zip");
	QueueEnsureTurboAsset("126 GingyandBordello BodyAcid.zip");
	QueueEnsureTurboAsset("126 Qoso Jura.zip");
	QueueEnsureTurboAsset("126 Rushmore Sensation.zip");
	QueueEnsureTurboAsset("126,4 DJPC GoToTheMoon.zip");
	QueueEnsureTurboAsset("127 Brodinski Oblivion.zip");
	QueueEnsureTurboAsset("127 Granit Polar.zip");
	QueueEnsureTurboAsset("128 Bleaker Untitled.zip");
	QueueEnsureTurboAsset("128 FrenchFries BugNoticed.zip");
	QueueEnsureTurboAsset("128 JeanNipon Rosso.zip");
	QueueEnsureTurboAsset("128 Photonz Errortrak.zip");
	QueueEnsureTurboAsset("129 Coni Flip.zip");
	QueueEnsureTurboAsset("130 Checkpoint Fast 1.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Fast 2.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Fast 3.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Fast 4.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Fast 5.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Fast 6.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Fast 7.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Fast 8.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Slow 1.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Slow 2.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Slow 3.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Slow 4.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Slow 5.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Slow 6.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Slow 7.ogg");
	QueueEnsureTurboAsset("130 Checkpoint Slow 8.ogg");
	QueueEnsureTurboAsset("130 Finish Line.ogg");
	QueueEnsureTurboAsset("130 Granit Cris.zip");
	QueueEnsureTurboAsset("130 Photonz Xabregas.zip");
	QueueEnsureTurboAsset("130 Start.ogg");
	QueueEnsureTurboAsset("130 StripSteve Metadata.zip");
	QueueEnsureTurboAsset("130 TheTown TheMovement.zip");
	QueueEnsureTurboAsset("130 TWR72 Stefan.zip");
	QueueEnsureTurboAsset("130 TWR72 Steie.zip");
	QueueEnsureTurboAsset("131,7 DJPC ControlExpansion.zip");
	QueueEnsureTurboAsset("132 Photonz Babalon.zip");
	QueueEnsureTurboAsset("133.41 Grassilac ShooBeeDoo.zip");
	QueueEnsureTurboAsset("135 DraftDodger Choon.zip");
	QueueEnsureTurboAsset("136 Cavart ClubSuede.zip");
	QueueEnsureTurboAsset("140 DeonCustom  Roses.zip");
	QueueEnsureTurboAsset("140 DraftDodger 928GTS.zip");
	QueueEnsureTurboAsset("151,7 Feadz Metaman.zip");
	QueueEnsureTurboAsset("87 Bustre Combine.zip");
	QueueEnsureTurboAsset("87 Droptek Colossus.zip");
	QueueEnsureTurboAsset("MusicReplay.ogg");
	QueueEnsureTurboAsset("starting.ogg");
	QueueEnsureTurboAsset("starting2.ogg");
	QueueEnsureTurboAsset("TMT_MENU_B1.ogg");
}

void QueueEnsureTurboAsset(const string &in asset) {
	if (initialTurboAssetDirList.Find(asset) > -1) return;
	if (IO::FileExists(Assets_DestDir + asset)) {
		warn("Unexpected File exists but not in init list: " + asset);
		return;
	}
	startnew(DownloadTurboAsset, asset);
}

int _TurboAssetDlSemaphore = 0;
int _TotalDownloadsStarted = 0;
int _TotalDownloadsDone = 0;
const int MAX_CONCURRENT_DOWNLOADS = 20;

void DownloadTurboAsset(const string &in asset) {
	_TotalDownloadsStarted++;
	while (_TurboAssetDlSemaphore >= MAX_CONCURRENT_DOWNLOADS) yield();
	_TurboAssetDlSemaphore++;
	try {
		string url = Assets_BaseUrl + asset.Replace(" ", "%20");
		string dest = Assets_DestDir + asset;
		trace("Downloading " + asset + " from " + url);

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
	_TurboAssetDlSemaphore--;
	_TotalDownloadsDone++;
}

void AwaitDownloadAllAssets() {
	yield(3);
	if (_TurboAssetDlSemaphore == 0) return;
	Notify("Waiting for " + _TotalDownloadsStarted + " assets to download...");
	while (_TurboAssetDlSemaphore > 0) yield();
	NotifySuccess("Downloaded " + _TotalDownloadsDone + " assets.");
}
