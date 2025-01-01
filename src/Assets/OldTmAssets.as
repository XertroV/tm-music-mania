const string OldAssets_BaseUrl = "https://assets.xk.io/OldTmMusic/";
const string OldAssets_RawBaseDir = "GameData/Media/Sounds/old/";
const string OldAssets_BaseDir = IO::FromAppFolder("GameData/Media/Sounds/old/");

const string MEDIA_SOUNDS_OLD = "file://Media/Sounds/old/";

string[] oldTm_MenuFiles;
string[] oldTm_RaceFiles;

const string OldAssetsIndex = """
TMN ESWC/04.Menu.ogg
TMN ESWC/Race/01.Tictac.ogg
TMN ESWC/Race/02.Pulp.ogg
TMN ESWC/Race/03.Start-Off.ogg
TMNF/Heartbeat(unverified-source).ogg
TMO/Alpine/Effects/AlpineBronze.wav
TMO/Alpine/Effects/AlpineCheckPoint.wav
TMO/Alpine/Effects/AlpineFinish.wav
TMO/Alpine/Effects/AlpineGold.wav
TMO/Alpine/Effects/AlpineLap.wav
TMO/Alpine/Effects/AlpineNadeo.wav
TMO/Alpine/Effects/AlpineNewRecord.wav
TMO/Alpine/Effects/AlpineRaceDefeat.wav
TMO/Alpine/Effects/AlpineSilver.wav
TMO/Alpine/Effects/AlpineZoom.wav
TMO/Alpine/Effects/AmbAlpine.ogg
TMO/Alpine/Race/alpine_edit.ogg
TMO/Alpine/Race/alpine_race.ogg
TMO/Alpine/Race/alpine_replay.ogg
TMO/menu_mod.ogg
TMO/Rally/Effects/AmbiWater.ogg
TMO/Rally/Effects/moulin.wav
TMO/Rally/Effects/RallyBronze.wav
TMO/Rally/Effects/RallyCheckPoint.wav
TMO/Rally/Effects/RallyFinish.wav
TMO/Rally/Effects/RallyGold.wav
TMO/Rally/Effects/RallyLap.wav
TMO/Rally/Effects/RallyNadeo.wav
TMO/Rally/Effects/RallyNewRecord.wav
TMO/Rally/Effects/RallyRaceDefeat.wav
TMO/Rally/Effects/RallySilver.wav
TMO/Rally/Effects/RallyZoom.wav
TMO/Rally/Race/rally_edit.ogg
TMO/Rally/Race/rally_race.ogg
TMO/Rally/Race/rally_replay.ogg
TMO/Speed/Effects/desert.ogg
TMO/Speed/Effects/SpeedBronze.wav
TMO/Speed/Effects/SpeedCheckPoint.wav
TMO/Speed/Effects/SpeedGold.wav
TMO/Speed/Effects/SpeedLap.wav
TMO/Speed/Effects/SpeedNadeo.wav
TMO/Speed/Effects/SpeedNewRecord.wav
TMO/Speed/Effects/SpeedRaceDefeat.wav
TMO/Speed/Effects/SpeedSilver.wav
TMO/Speed/Effects/SpeedZoom.wav
TMO/Speed/Race/speed_edit.ogg
TMO/Speed/Race/speed_race.ogg
TMO/Speed/Race/speed_replay.ogg
TMS/Bay/Hi-Jera Track 1.ogg
TMS/Bay/NBF Take Back.ogg
TMS/Bay/Silvermaker.ogg
TMS/Bay/The Brit Hoolas.ogg
TMS/Coast/21ST Century Beatnik One T.ogg
TMS/Coast/Big Wednesday Dont Worry.ogg
TMS/Coast/Jason Alner-Latin Trick.ogg
TMS/Coast/Mattie & Ben Track 4.ogg
TMS/Dom Lyne - Mutants.ogg
TMS/Island/Dan Money.ogg
TMS/Island/Mike Myler.ogg
TMS/Island/Zsolt Marx - Breathe 1.ogg
TMS/Island/Zsolt Marx Fill Your Pages.ogg
TMU/Race/TMU-Bay.ogg
TMU/Race/TMU-Coast.ogg
TMU/Race/TMU-Desert.ogg
TMU/Race/TMU-Island.ogg
TMU/Race/TMU-Rally.ogg
TMU/Race/TMU-Snow.ogg
TMU/Race/TMU-Stadium-Pulp-remix.ogg
TMU/Race/TMU-Stadium-Start-Off-remix.ogg
TMU/Race/TMU-Stadium-Tictac-remix.ogg
TMU/TMU-Menu.ogg
""";

string[]@ _oldTmAssetFiles = OldAssets_FilterOnlyMusicFiles(OldAssetsIndex.Split("\n"));

string[]@ OldAssets_FilterOnlyMusicFiles(string[]@ assetFiles) {
    array<string> filteredFiles;
    for (uint i = 0; i < assetFiles.Length; i++) {
        if (assetFiles[i].Length < 2) continue;
        string file = assetFiles[i];
        filteredFiles.InsertLast(file);
        // trace("Filtered: " + file);

        string lFile = file.ToLower();
        if (lFile.Contains("menu") || lFile.Contains("heartbeat")) {
            oldTm_MenuFiles.InsertLast(file);
        } else if (!lFile.Contains("effects")) {
            oldTm_RaceFiles.InsertLast(file);
        }
    }
    return filteredFiles;
}

AssetDownloader@ oldAssetDownloader = AssetDownloader("OldTmAssets", OldAssets_BaseUrl, OldAssets_RawBaseDir);

void DownloadAllOldTmAssets() {
    auto @filesInDir = IO_IndexFolderTrimmed(OldAssets_BaseDir, true);
    for (uint i = 0; i < _oldTmAssetFiles.Length; i++) {
        if (filesInDir.Find(_oldTmAssetFiles[i]) != -1) {
            trace("Skipping download of " + _oldTmAssetFiles[i] + " as it already exists");
            continue;
        }
        oldAssetDownloader.DownloadAsset_InBg(_oldTmAssetFiles[i]);
        yield();
    }
    oldAssetDownloader.AwaitDownloadAllAssets();
    CheckOldTmAssetsAndRegister();
}

void CheckOldTmAssetsAndRegister() {
    if (!IO::FolderExists(OldAssets_BaseDir)) {
        warn("OldTmAssets folder does not exist: " + OldAssets_BaseDir);
        return;
    }
    bool gotAll = true;
    gotAll = CheckOldTmAssetsSubfolderAndRegister("Old_Menus", oldTm_MenuFiles) && gotAll;
    gotAll = CheckOldTmAssetsSubfolderAndRegister("Old_Races", oldTm_RaceFiles) && gotAll;
    if (gotAll) {
        SetGotAssetPack("OldTmAssets");
    }
}

bool CheckOldTmAssetsSubfolderAndRegister(const string &in name, string[]@ files) {
    // c:/.../GameData/Media/Sounds/old/
    string subfolderDir = OldAssets_BaseDir; // + "/";
    if (!IO::FolderExists(subfolderDir)) {
        warn("OldAssetPack subfolder does not exist: " + subfolderDir);
        return false;
    }
    for (uint i = 0; i < files.Length; i++) {
        string file = files[i];
        if (!IO::FileExists(subfolderDir + file)) {
            warn("OldAssetPack file does not exist: " + subfolderDir + file);
            return false;
        }
    }
    RegisterOldAssetPack(name, files);
    return true;
}

void RegisterOldAssetPack(const string &in name, string[]@ files) {
    trace("Registering OldAssetPack: " + name);
    Packs::AddPack(AudioPack_Playlist(name, MEDIA_SOUNDS_OLD, files, 0.0));
}
