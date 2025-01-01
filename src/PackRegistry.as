void AddTurboToAudioPackRegistry() {
    Packs::AddPack(AudioPack_Playlist("Turbo Menu Music", MEDIA_SOUNDS_TURBO, {
        Playlist_Track(TurboConst::MusicMenuSimple, 0.0),
        Playlist_Track(TurboConst::MusicMenuSimple2, 6.0)
    }).WithBuiltin());

    Packs::AddPack(AudioPack_Playlist("Turbo Editor Music", MEDIA_SOUNDS_TURBO, {
        Playlist_Track("MapEditor/TMT_Trackbuilder_1.ogg", 0.0)
    }).WithBuiltin());

    Packs::AddPack(AudioPack_LoopsTurbo("Turbo In-Game Music", MEDIA_SOUNDS_TURBO, TurboMusicList).WithBuiltin());

    Packs::AddPack(AudioPack_GameSounds("Turbo In-Game Sounds", MEDIA_SOUNDS_TURBO, GameSoundsSpec(
        TurboConst::GetSoundsCheckpointFast(),
        TurboConst::GetSoundsCheckpointSlow(),
        TurboConst::GetSoundsFinishLap(),
        TurboConst::GetSoundsFinishRace(),
        TurboConst::GetSoundsStartRace(),
        TurboConst::GetSoundsRespawn()
    )).WithBuiltin());
}

namespace Packs {
    AudioPack@[] GameSounds;
    // AudioPack_GameSounds@[] GameSounds;
    AudioPack@[] Playlists;
    // AudioPack_Playlist@[] Playlists;
    AudioPack@[] LoopsTurbo;
    // AudioPack_LoopsTurbo@[] LoopsTurbo;
    AudioPack@[] EditorLoops;
    // AudioPack_LoopsEditor@[] EditorLoops;

    void AddPack(AudioPack_GameSounds@ pack) {
        AddToLookupIfNotExists(pack);
        GameSounds.InsertLast(pack);
        trace("Added GameSounds: " + pack.name);
    }

    void AddPack(AudioPack_Playlist@ pack) {
        AddToLookupIfNotExists(pack);
        Playlists.InsertLast(pack);
        trace("Added Playlist: " + pack.name);
    }

    void AddPack(AudioPack_LoopsTurbo@ pack) {
        AddToLookupIfNotExists(pack);
        LoopsTurbo.InsertLast(pack);
        trace("Added LoopsTurbo: " + pack.name);
    }

    void AddPack(AudioPack_LoopsEditor@ pack) {
        AddToLookupIfNotExists(pack);
        EditorLoops.InsertLast(pack);
        trace("Added LoopsEditor: " + pack.name);
    }

    dictionary PackLookup;

    void AddToLookupIfNotExists(AudioPack@ pack) {
        if (PackLookup.Exists(pack.name)) {
            throw("Pack already exists: " + pack.name);
            return;
        }
        @PackLookup[pack.name] = pack;
    }

    AudioPack@ GetPack(const string &in name) {
        if (PackLookup.Exists(name)) {
            return cast<AudioPack@>(PackLookup[name]);
        }
        warn("Pack not found: " + name);
        return AudioPack_Null(name);
    }

    AudioPack@ GetInGameMusic() {
        return GetPack(S_PackChoice_InGame);
    }
    AudioPack@ GetMenuMusic() {
        return GetPack(S_PackChoice_Menu);
    }
    AudioPack@ GetEditorMusic() {
        return GetPack(S_PackChoice_Editor);
    }
    AudioPack@ GetInGame_GameSounds() {
        return GetPack(S_PackChoice_InGameSounds);
    }


    [Setting hidden]
    string S_PackChoice_InGame = "Turbo In-Game Music";
    [Setting hidden]
    string S_PackChoice_InGameSounds = "Turbo In-Game Sounds";
    [Setting hidden]
    string S_PackChoice_Menu = "Turbo Menu Music";
    [Setting hidden]
    string S_PackChoice_Editor = "Turbo Editor Music";

    enum PackTy {
        LoopsTurbo = 1,
        GameSounds = 2,
        Playlist = 4,
        LoopsEditor = 8
    }

    void R_Packs_Settings() {
        UI::BeginTabBar("PacksTabBar");
        S_PackChoice_InGame = R_PackChoice("In-Game Music", S_PackChoice_InGame, PackTy::LoopsTurbo | PackTy::Playlist);
        S_PackChoice_InGameSounds = R_PackChoice("In-Game Sounds", S_PackChoice_InGameSounds, PackTy::GameSounds);
        S_PackChoice_Menu = R_PackChoice("Menu Music", S_PackChoice_Menu, PackTy::Playlist);
        S_PackChoice_Editor = R_PackChoice("Editor Music", S_PackChoice_Editor, PackTy::LoopsEditor | PackTy::Playlist);
        UI::EndTabBar();
    }

    string R_PackChoice(const string &in name, const string &in currentChoice, int allowedPackTypes = PackTy::Playlist) {
        if (UI::BeginTabItem(name)) {
            string choice = currentChoice;
            UI::Text("Current: " + choice);
            if (allowedPackTypes & PackTy::Playlist > 0) {
                UI::SeparatorText("Playlists");
                choice = DrawPackListChoice(Playlists, choice);
            }
            if (allowedPackTypes & PackTy::LoopsTurbo > 0) {
                UI::SeparatorText("Loops");
                choice = DrawPackListChoice(LoopsTurbo, choice);
            }
            if (allowedPackTypes & PackTy::LoopsEditor > 0) {
                UI::SeparatorText("Loops");
                choice = DrawPackListChoice(EditorLoops, choice);
            }
            if (allowedPackTypes & PackTy::GameSounds > 0) {
                UI::SeparatorText("Game Sounds");
                choice = DrawPackListChoice(GameSounds, choice);
            }
            // if (UI::Button("Choose Pack")) {
            //     choice = UI::SelectString("Choose Pack", choice, GetPackNames(allowedPackTypes));
            // }
            UI::EndTabItem();
            return choice;
        }
        return currentChoice;
    }

    string DrawPackListChoice(AudioPack@[]@ packs, const string &in currentChoice) {
        string choice = currentChoice;
        for (uint i = 0; i < packs.Length; i++) {
            AudioPack@ pack = packs[i];
            bool isSelected = pack.name == choice;
            if (pack.DrawChoiceRow(isSelected)) {
                choice = pack.name;
            }
        }
        return choice;
    }
}

enum AudioPackType {
    // like mp4, tm2020
    Playlist,
    // like turbo (low pass filter based on speed, etc)
    Loops_Turbo,
    // gamepad editor does this apparently
    Loops_Editor,
    // game sounds like checkpoint, finish, etc
    GameSounds
}

AudioPackType ParseAudioPackType(const string &in str) {
    if (str == "Playlist") {
        return AudioPackType::Playlist;
    } else if (str == "Loops_Turbo") {
        return AudioPackType::Loops_Turbo;
    } else if (str == "Loops_Editor") {
        return AudioPackType::Loops_Editor;
    } else if (str == "GameSounds") {
        return AudioPackType::GameSounds;
    }
    throw("Invalid AudioPackType: " + str);
    return AudioPackType::Playlist;
}

AudioPack@ AudioPack_FromJson(Json::Value@ j) {
    if (j.GetType() != Json::Type::Object) {
        throw("AudioPack_FromJson: expected object, got " + j.GetType());
    }

    AudioPackType ty = ParseAudioPackType(j["packType"]);

    switch (ty) {
        case AudioPackType::Playlist:
            return AudioPack_Playlist(j);
        case AudioPackType::Loops_Turbo:
            return AudioPack_LoopsTurbo(j);
        case AudioPackType::GameSounds:
            return AudioPack_GameSounds(j);
        case AudioPackType::Loops_Editor:
            throw("Loops_Editor not implemented");
            break;
    }
    throw("Invalid AudioPackType: " + tostring(ty));
    return null;
}

abstract class AudioPack {
    AudioPackType ty;
    string name;
    string tyAndName;

    AudioPack(AudioPackType ty, const string &in name) {
        this.ty = ty;
        this.name = name;
        SetTyAndName();
    }

    AudioPack(Json::Value@ j) {
        ty = ParseAudioPackType(j["packType"]);
        name = string(j["packName"]);
        SetTyAndName();
    }

    void SetTyAndName() {
        tyAndName = "[" + tostring(ty) + "] " + name;
    }

    Json::Value@ ToJson() {
        Json::Value@ j = Json::Object();
        j["packType"] = tostring(ty);
        j["packName"] = name;
        return j;
    }

    bool isBuiltin = false;

    bool DrawChoiceRow(bool isSelected) {
        UI::PushID(name);

        UI::Text(tyAndName);
        UI::SameLine();

        UI::BeginDisabled(isSelected);
        bool clicked = UX::SmallButton(Icons::HandPointerO);
        UI::EndDisabled();

        UI::PopID();
        return clicked;

    }

    MusicOrSound@ ToMusicOrSound() {
        throw("override ToMusicOrSound: " + (tyAndName));
        return null;
    }
}


class AudioPack_Null : AudioPack_Playlist {
    AudioPack_Null(const string &in name = "") {
        super("Null: " + (name.Length == 0 ? "-" : name), "null_dir", {});
    }

    AudioPack_Null(Json::Value@ j) {
        super(j);
        @tracks = {};
    }

    MusicOrSound@ ToMusicOrSound() override {
        return null;
    }
}


class AudioPack_LoopsGeneric : AudioPack {
    string baseDir;
    Loop_Zip@[] loops;

    AudioPack_LoopsGeneric(const string &in name, const string &in baseFolder, Json::Value@ jLoops) {
        super(AudioPackType::Loops_Turbo, name);
        this.baseDir = baseFolder;
        _LoadLoopsFromJsonArr(jLoops);
    }

    AudioPack_LoopsGeneric(Json::Value@ j) {
        super(j);
        baseDir = string(j["baseDir"]);
        _LoadLoopsFromJsonArr(j["loops"]);
    }

    private void _LoadLoopsFromJsonArr(Json::Value@ jArr) {
        for (uint i = 0; i < jArr.Length; i++) {
            loops.InsertLast(Loop_Zip(jArr[i]));
        }
    }

    Json::Value@ ToJson() override {
        Json::Value@ j = AudioPack::ToJson();
        j["baseDir"] = baseDir;
        j["loops"] = GetLoopsJsonArr();
        return j;
    }

    Json::Value@ GetLoopsJsonArr() {
        Json::Value@ jLoops = Json::Array();
        for (uint i = 0; i < loops.Length; i++) {
            jLoops.Add(loops[i].ToJsonArr());
        }
        return jLoops;
    }
}

class Loop_Zip {
    string fileName;
    float gain;
    string name;
    string label;
    string artist;

    Loop_Zip(Json::Value@ jArr) {
        fileName = string(jArr[0]);
        gain = float(jArr[1]);
        switch (jArr.Length) {
            case 9:
            case 8:
            case 7:
            case 6:
            case 5: artist = string(jArr[4]);
            case 4: label = string(jArr[3]);
            case 3: name = string(jArr[2]);
        }
    }

    Loop_Zip(const string &in fileName, float gain, const string &in name, const string &in label = "", const string &in artist = "") {
        this.fileName = fileName;
        this.gain = gain;
        this.name = name;
        this.label = label;
        this.artist = artist;
    }

    Json::Value@ ToJsonArr() {
        Json::Value@ jArr = Json::Array();
        jArr.Add(fileName);
        jArr.Add(gain);
        jArr.Add(name);
        jArr.Add(label);
        jArr.Add(artist);
        return jArr;
    }
}

class AudioPack_LoopsTurbo : AudioPack_LoopsGeneric {
    AudioPack_LoopsTurbo(const string &in name, const string &in baseFolder, Json::Value@ jLoops) {
        super(name, baseFolder, jLoops);
    }

    AudioPack_LoopsTurbo(Json::Value@ j) {
        super(j);
    }

    AudioPack_LoopsTurbo@ WithBuiltin() {
        isBuiltin = true;
        return this;
    }

    MusicOrSound@ ToMusicOrSound() override {
        dev_warn("AP_LoopsTurbo::ToMusicOrSound " + name);
        return Music_TurboInGame(GetLoopsJsonArr());
    }
}

class AudioPack_LoopsEditor : AudioPack_LoopsGeneric {
    AudioPack_LoopsEditor(const string &in name, const string &in baseFolder, Json::Value@ jLoops) {
        super(name, baseFolder, jLoops);
    }

    AudioPack_LoopsEditor(Json::Value@ j) {
        super(j);
    }

    AudioPack_LoopsEditor@ WithBuiltin() {
        isBuiltin = true;
        return this;
    }

    MusicOrSound@ ToMusicOrSound() override {
        dev_warn("AP_LoopsEditor::ToMusicOrSound " + name);
        // return Music_TurboEditor(GetLoopsJsonArr());
        throw("todo: ToMusicOrSound not implemented for LoopsEditor");
        return null;
    }
}



class AudioPack_Playlist : AudioPack {
    Playlist_Track@[]@ tracks;
    string baseDir;

    AudioPack_Playlist(const string &in name, const string &in baseFolder, Playlist_Track@[]@ tracks) {
        super(AudioPackType::Playlist, name);
        @this.tracks = tracks;
        this.baseDir = baseFolder;
    }

    AudioPack_Playlist(const string &in name, const string &in baseFolder, string[]@ trackFiles, float defaultVolume) {
        super(AudioPackType::Playlist, name);
        @tracks = {};
        this.baseDir = baseFolder;
        for (uint i = 0; i < trackFiles.Length; i++) {
            tracks.InsertLast(Playlist_Track(trackFiles[i]));
        }
    }

    AudioPack_Playlist(Json::Value@ j) {
        super(j);
        @tracks = {};
        baseDir = string(j["baseDir"]);
        Json::Value@ jTracks = j["tracks"];
        for (uint i = 0; i < jTracks.Length; i++) {
            tracks.InsertLast(Playlist_Track(jTracks[i]));
        }
    }

    Json::Value@ ToJson() override {
        Json::Value@ j = AudioPack::ToJson();
        j["baseDir"] = baseDir;
        Json::Value@ jTracks = Json::Array();
        for (uint i = 0; i < tracks.Length; i++) {
            jTracks.Add(tracks[i].ToJson());
        }
        j["tracks"] = jTracks;
        return j;
    }

    AudioPack_Playlist@ WithBuiltin() {
        isBuiltin = true;
        return this;
    }

    MusicOrSound@ ToMusicOrSound() override {
        dev_warn("AP_Playlist::ToMusicOrSound " + name);
        string[]@ paths = {};
        if (!baseDir.StartsWith("file://")) {
            throw("baseDir must start with file://; instead: " + baseDir);
        }
        for (uint i = 0; i < tracks.Length; i++) {
            paths.InsertLast(baseDir + tracks[i].name);
        }
        auto ret = Music_StdTrackSelection(baseDir, paths, true, true);
        for (uint i = 0; i < tracks.Length; i++) {
            ret.SetCustomVolume(tracks[i].volume, tracks[i].name);
        }
        return ret;
    }
}


class Playlist_Track {
    string name;
    // -40 for silent, 0 for normal, 6 is 6db amplification
    float volume;

    Playlist_Track(const string &in name, float volume = 0.0) {
        this.name = name;
        this.volume = volume;
    }

    Playlist_Track(Json::Value@ j) {
        name = string(j["n"]);
        volume = float(j["v"]);
    }

    Json::Value@ ToJson() {
        Json::Value@ j = Json::Object();
        j["n"] = name;
        j["v"] = volume;
        return j;
    }
}



class AudioPack_GameSounds : AudioPack {
    GameSoundsSpec@ spec;
    string baseDir;

    AudioPack_GameSounds(const string &in name, const string &in baseDir, GameSoundsSpec@ spec) {
        super(AudioPackType::GameSounds, name);
        this.baseDir = baseDir;
        @this.spec = spec;
    }

    AudioPack_GameSounds(Json::Value@ j) {
        super(j);
        @spec = GameSoundsSpec(j["spec"]);
        baseDir = string(j["baseDir"]);
    }

    Json::Value@ ToJson() override {
        Json::Value@ j = AudioPack::ToJson();
        j["spec"] = spec.ToJson();
        j["baseDir"] = baseDir;
        return j;
    }

    AudioPack_GameSounds@ WithBuiltin() {
        isBuiltin = true;
        return this;
    }

    MusicOrSound@ ToMusicOrSound() override {
        dev_warn("AP_GameSounds::ToMusicOrSound " + name);
        return GameSounds(name, baseDir, spec);
    }
}



class GameSoundsSpec {
    string[]@ checkpointFast;
    string[]@ checkpointSlow;
    string[]@ finishLap;
    string[]@ finishRace;
    string[]@ startRace;
    string[]@ respawn;

    GameSoundsSpec() {
        checkpointFast = {};
        checkpointSlow = {};
        finishLap = {};
        finishRace = {};
        startRace = {};
        respawn = {};
    }

    GameSoundsSpec(string[]@ checkpointFast, string[]@ checkpointSlow, string[]@ finishLap, string[]@ finishRace, string[]@ startRace, string[]@ respawn) {
        @this.checkpointFast = checkpointFast;
        @this.checkpointSlow = checkpointSlow;
        @this.finishLap = finishLap;
        @this.finishRace = finishRace;
        @this.startRace = startRace;
        @this.respawn = respawn;
    }

    GameSoundsSpec(Json::Value@ j) {
        @checkpointFast = Parse_JStrArr(j["checkpointFast"]);
        @checkpointSlow = Parse_JStrArr(j["checkpointSlow"]);
        @finishLap = Parse_JStrArr(j["finishLap"]);
        @finishRace = Parse_JStrArr(j["finishRace"]);
        @startRace = Parse_JStrArr(j["startRace"]);
        @respawn = Parse_JStrArr(j["respawn"]);
    }

    Json::Value@ ToJson() {
        Json::Value@ j = Json::Object();
        j["checkpointFast"] = checkpointFast.ToJson();
        j["checkpointSlow"] = checkpointSlow.ToJson();
        j["finishLap"] = finishLap.ToJson();
        j["finishRace"] = finishRace.ToJson();
        j["startRace"] = startRace.ToJson();
        j["respawn"] = respawn.ToJson();
        return j;
    }

    string[]@ GetCheckpoints(bool fast) {
        return fast ? checkpointFast : checkpointSlow;
    }
}


string[]@ Parse_JStrArr(Json::Value@ j) {
    string[]@ arr = {};
    for (uint i = 0; i < j.Length; i++) {
        arr.InsertLast(string(j[i]));
    }
    return arr;
}

string[]@ IO_IndexFolderTrimmed(const string &in path, bool recursive) {
    auto @files = IO::IndexFolder(path, recursive);
    for (uint i = 0; i < files.Length; i++) {
        auto @parts = files[i].Split(path);
        files[i] = parts[parts.Length - 1];
    }
    return files;
}
