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

    // SetGotAssetPack(TM_TURBO_AP_NAME);
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
            warn("Pack already exists: " + pack.name);
            return;
        }
        @PackLookup[pack.name] = pack;
    }

    bool HasPack(const string &in name) {
        return PackLookup.Exists(name);
    }

    void RemovePack(AudioPack@ pack) {
        if (PackLookup.Exists(pack.name)) {
            PackLookup.Delete(pack.name);
        }
        if (pack.ty & AudioPackType::GameSounds > 0) {
            RemovePackIfFound(pack, GameSounds);
        } else if (pack.ty & AudioPackType::Playlist > 0) {
            RemovePackIfFound(pack, Playlists);
        } else if (pack.ty & AudioPackType::Loops_Turbo > 0) {
            RemovePackIfFound(pack, LoopsTurbo);
        } else if (pack.ty & AudioPackType::Loops_Editor > 0) {
            RemovePackIfFound(pack, EditorLoops);
        }
    }

    bool RemovePackIfFound(AudioPack@ pack, AudioPack@[]@ arr) {
        auto ix = arr.FindByRef(pack);
        if (ix != -1) {
            arr.RemoveAt(ix);
            dev_trace("Removed pack: " + pack.name);
            return true;
        }
        dev_warn("RemovePackIfFound: not found: " + pack.name);
        return false;
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

    bool UpdateMenuMusicChoice(AudioPack@ pack) {
        if (pack.ty != AudioPackType::Playlist) {
            warn("UpdateMenuMusicChoice: expected Playlist, got " + tostring(pack.ty));
            return false;
        }
        bool changed = S_PackChoice_Menu != pack.name;
        S_PackChoice_Menu = pack.name;
        return changed;
    }

    bool UpdateInGameMusicChoice(AudioPack@ pack) {
        if (pack.ty & (AudioPackType::Loops_Turbo | AudioPackType::Playlist) == 0) {
            warn("UpdateInGameMusicChoice: expected Loops_Turbo|Playlist, got " + tostring(pack.ty));
            return false;
        }
        bool changed = S_PackChoice_InGame != pack.name;
        S_PackChoice_InGame = pack.name;
        return changed;
    }

    bool UpdateGameSoundsChoice(AudioPack@ pack) {
        if (pack !is null && pack.ty != AudioPackType::GameSounds) {
            warn("UpdateGameSoundsChoice: expected GameSounds, got " + tostring(pack.ty));
            return false;
        }
        bool changed = (pack is null && S_PackChoice_InGameSounds.Length > 0) || S_PackChoice_InGameSounds != pack.name;
        S_PackChoice_InGameSounds = pack is null ? "" : pack.name;
        return changed;
    }

    bool UpdateEditorMusicChoice(AudioPack@ pack) {
        if (pack.ty & (AudioPackType::Loops_Editor | AudioPackType::Playlist) == 0) {
            warn("UpdateEditorMusicChoice: expected Loops_Editor|Playlist, got " + tostring(pack.ty));
            return false;
        }
        bool changed = S_PackChoice_Editor != pack.name;
        S_PackChoice_Editor = pack.name;
        return changed;
    }

    enum PackTy {
        LoopsTurbo = 1,
        GameSounds = 2,
        Playlist = 4,
        LoopsEditor = 8
    }


    void R_Packs_Settings() {
        UI::BeginTabBar("PacksTabBar");
        S_PackChoice_InGame = R_PackChoice("In-Game Music", S_PackChoice_InGame, MusicCtx::InGame, PackTy::LoopsTurbo | PackTy::Playlist);
        S_PackChoice_InGameSounds = R_PackChoice("In-Game Sounds", S_PackChoice_InGameSounds, MusicCtx::InGame, PackTy::GameSounds);
        S_PackChoice_Menu = R_PackChoice("Menu Music", S_PackChoice_Menu, MusicCtx::Menu, PackTy::Playlist);
        S_PackChoice_Editor = R_PackChoice("Editor Music", S_PackChoice_Editor, MusicCtx::Editor, PackTy::LoopsEditor | PackTy::Playlist);

        if (UI::BeginTabItem("DLC")) {
            R_DownloadPacks();
            UI::EndTabItem();
        }
        UI::EndTabBar();
    }

    void R_DownloadPacks() {
        if (!DLC::IsAnyAvailable()) {
            UI::Text("All DLC Downloaded");
            return;
        }
        DLC::RenderDownloadMenu();
    }

    string R_PackChoice(const string &in name, const string &in currentChoice, MusicCtx mCtx, int allowedPackTypes = PackTy::Playlist) {
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
            if (choice != currentChoice) {
                Music::ReloadMusicFor(mCtx);
            }
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
    Playlist = 1,
    // like turbo (low pass filter based on speed, etc)
    Loops_Turbo = 2,
    // gamepad editor does this apparently
    Loops_Editor = 4,
    // game sounds like checkpoint, finish, etc
    GameSounds = 8
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

        UI::Text((isSelected ? "\\$8e8" : "") + tyAndName);
        UI::SameLine();

        UI::BeginDisabled(isSelected);
        bool clicked = UX::SmallButton(Icons::HandPointerO);
        UI::EndDisabled();

        UI::PopID();
        return clicked;

    }

    void RenderSongChoiceMenu() {
        throw("RenderSongChoiceMenu: Override me " + tyAndName);
    }

    MusicOrSound@ ToMusicOrSound() {
        throw("override ToMusicOrSound: " + (tyAndName));
        return null;
    }

    int GetTrackCount() {
        throw("override GetTrackCount: " + (tyAndName));
        return 0;
    }
}


class AudioPack_Null : AudioPack_Playlist {
    AudioPack_Null(const string &in name = "") {
        super("Null: " + (name.Length == 0 ? "-" : name), "file://null_dir", {});
    }

    AudioPack_Null(Json::Value@ j) {
        super(j);
        @tracks = {};
    }

    MusicOrSound@ ToMusicOrSound() override {
        return null;
    }

    int GetTrackCount() override {
        return -1;
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

    void RenderSongChoiceMenu() override {
        if (UI::BeginMenu(name)) {
            for (uint i = 0; i < loops.Length; i++) {
                if (UI::MenuItem(loops[i].name, "", false)) {
                    Music::SetCurrentMusicChoice(this);
                    this.SetCurrMusicPlayingIx(i);
                    dev_warn("todo: Selected: " + loops[i].name);
                }
            }
            UI::EndMenu();
        }
    }

    void SetCurrMusicPlayingIx(int64 ix) {
        auto musicLoops = cast<Music_TurboInGame>(Music::GetCurrentMusic());
        if (musicLoops !is null) {
            musicLoops.PickNewMusicTrack(ix);
        }
    }

    int GetTrackCount() override {
        return loops.Length;
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
        return Music_TurboInGame(name, baseDir, GetLoopsJsonArr()).WithOriginPack(this);
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
    AudioPack_Playlist@[] children;
    string baseDir;

    AudioPack_Playlist(const string &in name, const string &in baseFolder, Playlist_Track@[]@ tracks) {
        super(AudioPackType::Playlist, name);

        this.baseDir = baseFolder;
        if (!baseDir.StartsWith("file://")) {
            throw("baseDir must start with file://; instead: " + baseDir);
        }

        @this.tracks = tracks;
        for (uint i = 0; i < tracks.Length; i++) {
            OnAddTrack(i);
        }
    }

    AudioPack_Playlist(const string &in name, const string &in baseFolder, string[]@ trackFiles, float defaultVolume) {
        super(AudioPackType::Playlist, name);
        @tracks = {};
        this.baseDir = baseFolder;
        for (uint i = 0; i < trackFiles.Length; i++) {
            if (trackFiles[i].Length < 2) continue;
            AddTrack(Playlist_Track(trackFiles[i]));
        }
    }

    AudioPack_Playlist(Json::Value@ j) {
        super(j);
        @tracks = {};
        baseDir = string(j["baseDir"]);
        Json::Value@ jTracks = j["tracks"];
        for (uint i = 0; i < jTracks.Length; i++) {
            AddTrack(Playlist_Track(jTracks[i]));
        }
    }

    void AddTrack(Playlist_Track@ track) {
        tracks.InsertLast(track);
        OnAddTrack(tracks.Length - 1);
    }

    void RemoveAllTracks() {
        for (uint i = 0; i < tracks.Length; i++) {
            OnRemoveTrack(i);
        }
        tracks.RemoveRange(0, tracks.Length);
    }

    bool RemoveTrack(Playlist_Track@ track) {
        for (uint i = 0; i < tracks.Length; i++) {
            if (tracks[i].name == track.name) {
                OnRemoveTrack(i);
                tracks.RemoveAt(i);
                return true;
            }
        }
        return false;
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
        auto ret = Music_StdTrackSelection(name, baseDir, paths, true, true)
            .WithOriginPack(this);
        for (uint i = 0; i < tracks.Length; i++) {
            ret.SetCustomVolume(tracks[i].volume, tracks[i].name);
        }
        return ret;
    }

    void RenderSongChoiceMenu() override {
        auto musicStdPlaylist = cast<Music_StdTrackSelection>(Music::GetCurrentMusic());
        auto currMusic = musicStdPlaylist !is null ? musicStdPlaylist.CurrMusicPath : "";
        if (UI::BeginMenu(name)) {
            for (uint i = 0; i < tracks.Length; i++) {
                if (UI::MenuItem(tracks[i].name, "", currMusic == tracks[i].name)) {
                    Music::SetCurrentMusicChoice(this);
                    startnew(CoroutineFuncUserdataInt64(this.SetCurrMusicPlayingIx), int64(i));
                    dev_warn("Selected: " + tracks[i].name);
                }
            }
            if (tracks.Length == 0) {
                UI::Text("\\$999\\$iNo tracks");
            }
            UI::EndMenu();
        }
    }

    void SetCurrMusicPlayingIx(int64 ix) {
        while (Music::GetCurrentMusic() is null) {
            yield();
        }
        auto musicStdPlaylist = cast<Music_StdTrackSelection>(Music::GetCurrentMusic());
        if (musicStdPlaylist !is null) {
            musicStdPlaylist.SelectAndPreloadTrack(ix);
        }
    }

    int GetTrackCount() override {
        return tracks.Length;
    }

    void OnAddTrack(int i) {
        // overridden in AudioPack_PlaylistEverything
        if (AllMusicPlaylistSingleton !is null) {
            AllMusicPlaylistSingleton.AddTrack(tracks[i].CloneButAdjustBaseDir(MEDIA_URI, baseDir));
        }
    }

    void OnRemoveTrack(int i) {
        // overridden in AudioPack_PlaylistEverything
        if (AllMusicPlaylistSingleton !is null) {
            AllMusicPlaylistSingleton.RemoveTrack(tracks[i].CloneButAdjustBaseDir(MEDIA_URI, baseDir));
        }
    }

    void InvalidateMusicIfAny() {
        for (uint i = 0; i < children.Length; i++) {
            children[i].InvalidateMusicIfAny();
        }

        // if we invalidate music that's currently playing, we need to trigger an update in case of embedded music (which can start playing).
        // test TM_State after invalidation: we only need to refresh if we're in that context atm.
        bool any = false;
        any = (InvalidateMusicIfFor(MusicCtx::InGame) && TM_State::IsInPlayground) || any;
        any = (InvalidateMusicIfFor(MusicCtx::Editor) && TM_State::IsInEditor) || any;
        any = (InvalidateMusicIfFor(MusicCtx::Menu) && TM_State::IsInMenu) || any;
        if (any) {
            // trigger a reload of the music
            startnew(Music::OnGameContextChanged);
        }
    }

    bool InvalidateMusicIfFor(MusicCtx mCtx) {
        auto m = Music::GetMusicFor(mCtx);
        if (m !is null && m.origin is this) {
            Music::ReloadMusicFor(mCtx);
            return true;
        }
        return false;
    }

    protected void ClearChildren() {
        for (uint i = 0; i < children.Length; i++) {
            children[i].RemoveAllTracks();
            Packs::RemovePack(children[i]);
        }
        children.RemoveRange(0, children.Length);
    }

    void RenderChildrenSongChoice(bool addSep = false) {
        if (children.Length > 0) {
            if (addSep) UI::SeparatorText("SubLists");
            for (uint i = 0; i < children.Length; i++) {
                children[i].RenderSongChoiceMenu();
            }
        }
    }

    AudioPack_Playlist@ WithSubLists(PackDownloadable::PackSubList@[]@ subLists) {
        // todo
        if (Time::Stamp > 1736897331) throw("todo: WithSubLists");
        // todo: custom behaviro if start of regex is `^<name>/`
        // impl
        return this;
    }

    // void AddSubDirIfDir(const string &in fileOrDir) {
    //     if (!fileOrDir.EndsWith('/')) return;
    //     auto playListName = "<" + fileOrDir.SubStr(0, fileOrDir.Length - 1) + ">";
    //     auto @fileList = IO_IndexFolderTrimmed(CUSTOM_MUSIC_FOLDER + fileOrDir, true);
    //     children.InsertLast(AudioPack_Playlist(playListName, MEDIA_CUSTOM_URI + fileOrDir, fileList, 0.0));
    //     Packs::AddPack(children[children.Length - 1]);
    //     trace("Created custom music sub-playlist: " + playListName);
    // }
}

const string MEDIA_URI = "file://Media/";
const string MEDIA_CUSTOM_URI = "file://Media/CustomMusic/";
const string MEDIA_CUSTOM_GS_URI = "file://Media/CustomGameSounds/";

AudioPack_PlaylistEverything@ AllMusicPlaylistSingleton = null;

class AudioPack_PlaylistEverything : AudioPack_Playlist {
    AudioPack_PlaylistEverything(const string &in name) {
        if (AllMusicPlaylistSingleton !is null) {
            throw("Only one instance of AudioPack_PlaylistEverything allowed");
        }
        @AllMusicPlaylistSingleton = this;
        super(name, MEDIA_URI, {});
    }

    void OnAddTrack(int i) override {
        // do nothing here
    }

    void OnRemoveTrack(int i) override {
        // do nothing here
    }
}

AudioPack_PlaylistCustomDir@ CustomMusicPlaylistSingleton = null;

class AudioPack_PlaylistCustomDir : AudioPack_Playlist {

    // on-disk dir: CUSTOM_MUSIC_FOLDER
    AudioPack_PlaylistCustomDir(const string &in name) {
        if (CustomMusicPlaylistSingleton !is null) {
            throw("Only one instance of AudioPack_PlaylistCustomDir allowed");
        }
        @CustomMusicPlaylistSingleton = this;
        super(name, MEDIA_CUSTOM_URI, {});
        OnClickRefresh();
    }

    void OnClickRefresh() {
        startnew(CoroutineFunc(this.RescanDir));
    }

    protected void RescanDir() {
        if (!IO::FolderExists(CUSTOM_MUSIC_FOLDER)) return;

        // invalidate while we have children
        InvalidateMusicIfAny();
        RemoveAllTracks();
        ClearChildren();

        auto @files = IO_IndexFolderTrimmed(CUSTOM_MUSIC_FOLDER, false);
        for (uint i = 0; i < files.Length; i++) {
            AddTrackIfMusic(files[i]);
            AddSubDirIfDir(files[i]);
        }
    }

    void AddSubDirIfDir(const string &in fileOrDir) {
        if (!fileOrDir.EndsWith('/')) return;
        auto playListName = "<" + fileOrDir.SubStr(0, fileOrDir.Length - 1) + ">";
        auto @fileList = IO_IndexFolderTrimmed(CUSTOM_MUSIC_FOLDER + fileOrDir, true);
        children.InsertLast(AudioPack_Playlist(playListName, MEDIA_CUSTOM_URI + fileOrDir, fileList, 0.0));
        Packs::AddPack(children[children.Length - 1]);
        trace("Created custom music sub-playlist: " + playListName);
    }

    void AddTrackIfMusic(const string &in file) {
        if (file.EndsWith(".ogg") || file.EndsWith(".wav")) {
            AddTrack(Playlist_Track(file));
        }
    }

    void InvalidateMusicIfAny() override {
        AudioPack_Playlist::InvalidateMusicIfAny();
    }

    void RenderSongChoiceMenu() override {
        AudioPack_Playlist::RenderSongChoiceMenu();
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

    Playlist_Track@ CloneButAdjustBaseDir(const string &in newBaseDir, const string &in oldBaseDir) {
        if (!oldBaseDir.StartsWith(newBaseDir)) {
            throw("oldBaseDir must start with newBaseDir; instead: " + oldBaseDir + " vs " + newBaseDir);
        }
        string newName = (oldBaseDir + name).Replace(newBaseDir, "");
        return Playlist_Track(newName, volume);
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
        return GameSounds(name, baseDir, spec).WithOriginPack(this);
    }

    void RenderSongChoiceMenu() override {
        if (UI::MenuItem(name, "", Music::GetCurrentGameSoundPackName() == name)) {
            dev_warn("ap_gamesounds: Selected: " + name);
            Music::SetGameSoundPack(this);
        }
        // if (UI::BeginMenu(name)) {
        //     for (uint i = 0; i < spec.checkpointFast.Length; i++) {
        //         if (UI::MenuItem(spec.checkpointFast[i], "", false)) {
        //             dev_warn("Selected: " + spec.checkpointFast[i]);
        //         }
        //     }
        //     UI::EndMenu();
        // }
    }

    int GetTrackCount() override {
        return 1;
    }

    int GetTotalSoundCount() {
        if (spec is null) return -1;
        return spec.checkpointFast.Length + spec.checkpointSlow.Length + spec.finishLap.Length + spec.finishRace.Length + spec.startRace.Length + spec.respawn.Length
            + spec.medalBronze.Length + spec.medalSilver.Length + spec.medalGold.Length + spec.medalAuthor.Length;
    }

    void ListAllSoundsAsMenu() {
        if (UI::BeginMenu(name)) {
            ListSoundsAsMenu("CP Fast", spec.checkpointFast);
            ListSoundsAsMenu("CP Slow", spec.checkpointSlow);
            ListSoundsAsMenu("Finish Race", spec.finishRace);
            ListSoundsAsMenu("Finish Lap", spec.finishLap);
            ListSoundsAsMenu("Start Race", spec.startRace);
            ListSoundsAsMenu("Respawn", spec.respawn);
            ListSoundsAsMenu("Medal: Author", spec.medalAuthor);
            ListSoundsAsMenu("Medal: Gold", spec.medalGold);
            ListSoundsAsMenu("Medal: Silver", spec.medalSilver);
            ListSoundsAsMenu("Medal: Bronze", spec.medalBronze);
            UI::EndMenu();
        }
    }

    void ListSoundsAsMenu(const string &in name, string[]@ files) {
        if (files.Length == 0) {
            UI::Text("\\$999\\$iNo sounds for " + name);
            return;
        }
        if (UI::BeginMenu(name)) {
            for (uint i = 0; i < files.Length; i++) {
                UI::MenuItem(files[i], "", false, false);
            }
            UI::EndMenu();
        }
    }
}


AudioPack_GameSounds_CustomDir@ CustomGameSoundsSingleton = null;

class AudioPack_GameSounds_CustomDir : AudioPack_GameSounds {
    // on-disk dir: CUSTOM_MUSIC_FOLDER
    AudioPack_GameSounds_CustomDir(const string &in name) {
        if (CustomGameSoundsSingleton !is null) {
            throw("Only one instance of AudioPack_GameSounds_CustomDir allowed");
        }
        dev_warn("AP_GameSounds_CustomDir: " + name);
        @CustomGameSoundsSingleton = this;
        super(name, MEDIA_CUSTOM_GS_URI, GameSoundsSpec());
        OnClickRefresh();
    }

    void OnClickRefresh() {
        startnew(CoroutineFunc(this.RescanDir));
    }

    protected void RescanDir() {
        if (!IO::FolderExists(CUSTOM_GameSounds_FOLDER)) return;

        spec.checkpointFast.RemoveRange(0, spec.checkpointFast.Length);
        spec.checkpointSlow.RemoveRange(0, spec.checkpointSlow.Length);
        spec.finishLap.RemoveRange(0, spec.finishLap.Length);
        spec.finishRace.RemoveRange(0, spec.finishRace.Length);
        spec.startRace.RemoveRange(0, spec.startRace.Length);
        spec.respawn.RemoveRange(0, spec.respawn.Length);
        spec.medalBronze.RemoveRange(0, spec.medalBronze.Length);
        spec.medalSilver.RemoveRange(0, spec.medalSilver.Length);
        spec.medalGold.RemoveRange(0, spec.medalGold.Length);
        spec.medalAuthor.RemoveRange(0, spec.medalAuthor.Length);

        auto @files = IO_IndexFolderTrimmed(CUSTOM_GameSounds_FOLDER, true);
        files.SortAsc();
        for (uint i = 0; i < files.Length; i++) {
            AddSoundIfValidPath(files[i]);
        }

        InvalidateSoundsIfAny();
    }

    void AddSoundIfValidPath(const string &in file) {
        if (file.EndsWith(".ogg") || file.EndsWith(".wav")) {
            AddSoundByName(file);
        } else if (!file.EndsWith(".txt")) {
            NotifyWarning("Invalid file in CustomGameSounds folder: " + file);
        }
    }

    // assumes file is ogg/wav
    void AddSoundByName(const string &in path) {
        if (path.StartsWith("cpFast_")) {
            spec.checkpointFast.InsertLast(path);
        } else if (path.StartsWith("cpSlow_")) {
            spec.checkpointSlow.InsertLast(path);
        } else if (path.StartsWith("finish_")) {
            spec.finishRace.InsertLast(path);
        } else if (path.StartsWith("lap_")) {
            spec.finishLap.InsertLast(path);
        } else if (path.StartsWith("start_")) {
            spec.startRace.InsertLast(path);
        } else if (path.StartsWith("respawn_")) {
            spec.respawn.InsertLast(path);
        } else if (path.StartsWith("ma_")) {
            spec.medalAuthor.InsertLast(path);
        } else if (path.StartsWith("mg_")) {
            spec.medalGold.InsertLast(path);
        } else if (path.StartsWith("ms_")) {
            spec.medalSilver.InsertLast(path);
        } else if (path.StartsWith("mb_")) {
            spec.medalBronze.InsertLast(path);
        } else {
            NotifyWarning("Invalid file in CustomGameSounds folder: " + path);
        }
    }

    void InvalidateSoundsIfAny() {
        auto m = Music::GetCurrentGameSounds();
        if (m !is null && m.origin is this && TM_State::IsInPlayground) {
            Music::ClearGameSounds();
            // trigger a reload of the music
            startnew(Music::OnGameContextChanged);
        }
    }
}

const string CUSTOM_GS_SPEC = """
You can register sounds to be played when certain events occur in the game.
You can add as many sounds for each event as you like, and they will be mostly chosen at random.
Exception: checkpoint sounds are chosen based on the number of checkpoints and whether the player is faster or slower than PB (blue or red splits). This might not work correctly everywhere. If the checkpoint number is higher than the number of sounds, a random one will be chosen.

Each event is associated with a file prefix, e.g. "cpFast" is associated with Fast Checkpoint events. "mg" is associated with Medal Gold events. And so on.
Sound files for that event should be named like "cpFast_1.ogg", "cpFast_2.wav", "start_4.wav", etc. (You can use ogg or wav.)
Also note that file names are case-insensitive.
If you have more than 9 files for an event, you should use leading zeros in the file names, e.g. "cpFast_01.ogg", "cpFast_02.wav", "start_04.wav", etc. (Files are sorted by alphabetically when added.)

If no file names match an event, no sound will play.

Event Types
===========

- `cpFast`: Checkpoint Fast
- `cpSlow`: Checkpoint Slow
- `finish`: Finish
- `lap`: Finish Lap
- `start`: Start
- `respawn`: Respawn
- `ma`: Author Medal
- `mg`: Gold Medal
- `ms`: Silver Medal
- `mb`: Bronze Medal

CP Example
==========

The player is getting their 2nd checkpoint and is slower than pb.
The file played will be the 2nd file starting with `cpSlow_` when the files are sorted alphabetically.
so if there are 3 files: `cpSlow_01.ogg`, `cpSlow_02.wav`, `cpSlow_03.wav`, then the _02 file will be played.

For the players 4th and later CP, one of the 3 files will be chosen at random.
""";


class GameSoundsSpec {
    string[]@ checkpointFast;
    string[]@ checkpointSlow;
    string[]@ finishLap;
    string[]@ finishRace;
    string[]@ startRace;
    string[]@ respawn;
    string[]@ medalBronze;
    string[]@ medalSilver;
    string[]@ medalGold;
    string[]@ medalAuthor;

    GameSoundsSpec() {
        @checkpointFast = {};
        @checkpointSlow = {};
        @finishLap = {};
        @finishRace = {};
        @startRace = {};
        @respawn = {};
        @medalBronze = {};
        @medalSilver = {};
        @medalGold = {};
        @medalAuthor = {};
    }

    GameSoundsSpec(string[]@ checkpointFast, string[]@ checkpointSlow, string[]@ finishLap, string[]@ finishRace, string[]@ startRace, string[]@ respawn,
        string[]@ medalBronze = {}, string[]@ medalSilver = {}, string[]@ medalGold = {}, string[]@ medalAuthor = {}
    ) {
        @this.checkpointFast = checkpointFast;
        @this.checkpointSlow = checkpointSlow;
        @this.finishLap = finishLap;
        @this.finishRace = finishRace;
        @this.startRace = startRace;
        @this.respawn = respawn;
        @this.medalBronze = medalBronze;
        @this.medalSilver = medalSilver;
        @this.medalGold = medalGold;
        @this.medalAuthor = medalAuthor;
    }

    GameSoundsSpec(Json::Value@ j) {
        @checkpointFast = Parse_JStrArr(j["checkpointFast"]);
        @checkpointSlow = Parse_JStrArr(j["checkpointSlow"]);
        @finishLap = Parse_JStrArr(j["finishLap"]);
        @finishRace = Parse_JStrArr(j["finishRace"]);
        @startRace = Parse_JStrArr(j["startRace"]);
        @respawn = Parse_JStrArr(j["respawn"]);
        @medalBronze = Parse_JStrArr(j["medalBronze"]);
        @medalSilver = Parse_JStrArr(j["medalSilver"]);
        @medalGold = Parse_JStrArr(j["medalGold"]);
        @medalAuthor = Parse_JStrArr(j["medalAuthor"]);
    }

    Json::Value@ ToJson() {
        Json::Value@ j = Json::Object();
        j["checkpointFast"] = checkpointFast.ToJson();
        j["checkpointSlow"] = checkpointSlow.ToJson();
        j["finishLap"] = finishLap.ToJson();
        j["finishRace"] = finishRace.ToJson();
        j["startRace"] = startRace.ToJson();
        j["respawn"] = respawn.ToJson();
        j["medalBronze"] = medalBronze.ToJson();
        j["medalSilver"] = medalSilver.ToJson();
        j["medalGold"] = medalGold.ToJson();
        j["medalAuthor"] = medalAuthor.ToJson();
        return j;
    }

    string[]@ GetCheckpoints(bool fast) {
        return fast ? checkpointFast : checkpointSlow;
    }
}


string[]@ Parse_JStrArr(Json::Value@ j) {
    string[]@ arr = {};
    if (j.GetType() == Json::Type::Null) return arr;
    if (j.GetType() != Json::Type::Array) throw("Parse_JStrArr expected array, got " + j.GetType());
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
