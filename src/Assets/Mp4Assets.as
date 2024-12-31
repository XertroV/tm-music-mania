const string Mp4Assets_BaseUrl = "https://assets.xk.io/Mp4Music/";
const string Mp4Assets_BaseDir = IO::FromAppFolder("GameData/Media/Sounds/Turbo/");

string[] smStormFiles;
string[] canyonFiles;
string[] lagoonFiles;
string[] valleyFiles;
string[] stadiumFiles;

// zip files exist online but will be skipped for download
const string Mp4AssetFiles = """
SMStorm/NIGHT_01_Track_06.ogg
SMStorm/DAY_03_Track_05.ogg
SMStorm/DAY_01_Track_03.ogg
SMStorm/DAY_02_Track_04.ogg
SMStorm/NIGHT_02_Track_07.ogg

Canyon/Canyon2b.ogg
Canyon/Canyon4b.ogg
Canyon/Canyon2.ogg
Canyon/Canyon3.ogg
Canyon/Canyon4.ogg
Canyon/Canyon3b.ogg
Canyon/Canyon1b.ogg
Canyon/Canyon1.ogg

Lagoon/5. Sunrise - Lucky Cat.ogg
Lagoon/6. Sunrise - Yenset.ogg
Lagoon/4. Night - Tribe Diamond.ogg
Lagoon/7. Sunset - Ridge Roller.ogg
Lagoon/2. Day - White Sands.ogg
Lagoon/3. Night - Nervous.ogg
Lagoon/1. Sunset&Day - Thunder.ogg

Valley/7. Night - Ritual.ogg
Valley/5. Sunset - Setting.ogg
Valley/3. Day - Vast Veridian.ogg
Valley/6. Night - Extra Cologne.ogg
Valley/1. Sunrise - Forecast.ogg
Valley/2. Sunrise&Day - Orange.ogg
Valley/4. Sunset - Perforated Landscape.ogg

Stadium/Tail Lights.ogg
Stadium/Hydroplane.ogg
Stadium/Air Time.ogg
Stadium/Tachmania.ogg
Stadium/Dashboard.ogg

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
