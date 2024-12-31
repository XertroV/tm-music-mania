const string Mp4Assets_BaseUrl = "https://assets.xk.io/Mp4Music/";
const string Mp4Assets_BaseDir = IO::FromAppFolder("GameData/Media/Sounds/Turbo/");

string[] smStormFiles;
string[] canyonFiles;
string[] lagoonFiles;
string[] valleyFiles;
string[] stadiumFiles;

// zip files exist online but will be skipped for download
const string Mp4AssetFiles = """
SMStorm_music/NIGHT_01_Track_06.ogg
SMStorm_music/DAY_03_Track_05.ogg
SMStorm_music/DAY_01_Track_03.ogg
SMStorm_music/DAY_02_Track_04.ogg
SMStorm_music/NIGHT_02_Track_07.ogg

CanyonMusic/Canyon2b.ogg
CanyonMusic/Canyon4b.ogg
CanyonMusic/Canyon2.ogg
CanyonMusic/Canyon3.ogg
CanyonMusic/Canyon4.ogg
CanyonMusic/Canyon3b.ogg
CanyonMusic/Canyon1b.ogg
CanyonMusic/Canyon1.ogg

TMLagoon_music/TM Lagoon - 5. Sunrise - Lucky Cat.ogg
TMLagoon_music/TM Lagoon - 6. Sunrise - Yenset.ogg
TMLagoon_music/TM Lagoon - 4. Night - Tribe Diamond.ogg
TMLagoon_music/TM Lagoon - 7. Sunset - Ridge Roller.ogg
TMLagoon_music/TM Lagoon - 2. Day - White Sands.ogg
TMLagoon_music/TM Lagoon - 3. Night - Nervous.ogg
TMLagoon_music/TM Lagoon - 1. Sunset&Day - Thunder.ogg

TMValley_music/TM Valley - 7. Night - Ritual.ogg
TMValley_music/TM Valley - 5. Sunset - Setting.ogg
TMValley_music/TM Valley - 3. Day - Vast Veridian.ogg
TMValley_music/TM Valley - 6. Night - Extra Cologne.ogg
TMValley_music/TM Valley - 1. Sunrise - Forecast.ogg
TMValley_music/TM Valley - 2. Sunrise&Day - Orange.ogg
TMValley_music/TM Valley - 4. Sunset - Perforated Landscape.ogg

TMStadium_music/TM Stadium Sountrack - Tail Lights.ogg
TMStadium_music/TM Stadium Sountrack - Hydroplane.ogg
TMStadium_music/TM Stadium Sountrack - Air Time.ogg
TMStadium_music/TM Stadium Sountrack - Tachmania.ogg
TMStadium_music/TM Stadium Sountrack - Dashboard.ogg

TMValley_music.zip
TMLagoon_music.zip
SMStorm_music.zip
TMStadium_music.zip
""";

string[]@ _mp4AssetFiles = FilterOnlyMusicFiles(Mp4AssetFiles.Split("\n"));

string[]@ FilterOnlyMusicFiles(string[]@ assetFiles) {
    array<string> filteredFiles;
    for (uint i = 0; i < assetFiles.Length; i++) {
        if (assetFiles[i].Length < 2) continue;
        if (assetFiles[i].EndsWith(".zip")) continue;
        filteredFiles.InsertLast(assetFiles[i]);
        trace("Filtered: " + assetFiles[i]);
    }
    return filteredFiles;
}
