const string TurboAssets_BaseUrl = "https://assets.xk.io/TurboMusic/";
const string TurboAssets_DestDir = IO::FromAppFolder("GameData/Media/Sounds/Turbo/");
const string TurboAssets_RawDestDir = "GameData/Media/Sounds/Turbo/";

string[]@ initialTurboAssetDirList;

// creates DestDir for us
AssetDownloader@ turboAssetDownloader = AssetDownloader(TM_TURBO_AP_NAME, TurboAssets_BaseUrl, TurboAssets_RawDestDir);

void EnsureTurboAssets() {
	@initialTurboAssetDirList = IO_IndexFolderTrimmed(TurboAssets_DestDir, true);
	// for (uint i = 0; i < initialTurboAssetDirList.Length; i++) {
	// 	auto @parts = initialTurboAssetDirList[i].Split("/Media/Sounds/Turbo/");
	// 	initialTurboAssetDirList[i] = parts[parts.Length - 1];
	// }
	trace("initialTurboAssetDirList: " + Json::Write(initialTurboAssetDirList.ToJson()));
	QueueEnsureTurboAssetsDownloaded();
	turboAssetDownloader.AwaitDownloadAllAssets();
	AddTurboToAudioPackRegistry();
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
	QueueEnsureTurboAsset("MapEditor/PlaceDeco_Tree.wav");
	QueueEnsureTurboAsset("MapEditor/PlaceTerrain_Beach.wav");
	QueueEnsureTurboAsset("MapEditor/PlaceTerrain_Mountain.wav");
	QueueEnsureTurboAsset("MapEditor/PlaceTrack_Road.wav");
	QueueEnsureTurboAsset("MapEditor/PlaceTrack_ThemePark.wav");
	QueueEnsureTurboAsset("MapEditor/RandomGeneration.zip");
	QueueEnsureTurboAsset("MapEditor/RdmGen_Finished.ogg");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_AutomaticFinishTrack.ogg");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_BlocMove.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_BlocMoveDown.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_BlocMoveUp.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_BlocPlaceCheckpoint.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_BlocPlaceCommon.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_BlocPlaceDeco.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_BlocPlaceFinish.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_BlocPlaceStart.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_BlocRemove.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_BlocRotate.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_ClicInterfaceLeftRight.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_ClicInterfaceUpDown.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_ClicRosace.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_Pop-UpQuestionScreen.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_Pop-Up_InterfaceBlocCategory.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_Pop-Up_InterfaceSmall.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_TerminateValidateTrack.ogg");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_TestTrack.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_UI_WrongAction.wav");
	QueueEnsureTurboAsset("MapEditor/SFX_WhooshCam.ogg");
	QueueEnsureTurboAsset("MapEditor/TMT_Trackbuilder_1.ogg");
}

void QueueEnsureTurboAsset(const string &in asset) {
	if (initialTurboAssetDirList.Find(asset) > -1) return;
	if (IO::FileExists(TurboAssets_DestDir + asset)) {
		warn("Unexpected File exists but not in init list: " + asset);
		return;
	}
	turboAssetDownloader.DownloadAsset_InBg(asset);
	yield();
}
