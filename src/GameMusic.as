const Meta::RunContext MUSIC_RUN_CTX = Meta::RunContext::AfterMainLoop;

namespace GameMusic {
    // 51 and 57 for main menu and in-game atm
    uint[] musicTrackIndexes;
    bool[] musicTracksWerePlaying;
    string[] musicTracksFidNames;
    uint lastApSourcesLen = 0;

    float targetVolume = -100.0f;

    void Main() {
        startnew(GameMusic::MainAsync).WithRunContext(MUSIC_RUN_CTX);
    }

    void MainAsync() {
        while (true) {
            SilenceMusics();
            yield();
        }
    }

    [Setting hidden]
    bool windowOpen = true;

    [Setting hidden]
    bool S_PrioritizeMusicInMap = true;

    [Setting hidden]
    bool S_SetMusicInMapVolume = true;

    [Setting hidden]
    float S_MusicInMapVolume = 3.0;

    void RenderMenu() {
        if (UI::MenuItem("Music Mania Debug", "", windowOpen)) {
            windowOpen = !windowOpen;
        }
    }

    void Render() {
        if (!windowOpen) return;
        if (UI::Begin("Music Mania Debug", windowOpen, UI::WindowFlags::AlwaysAutoResize | UI::WindowFlags::NoCollapse)) {
            UI::Text("Music Track Indexes: " + musicTrackIndexes.Length);
            UI::Text("\\$i> " + Json::Write(musicTrackIndexes.ToJson()));
            UI::Text("\\$i" + Icons::PlayCircle + ": " + Json::Write(GetMTIsPlaying().ToJson()));
            DrawPlayingVolumes();
            if (UI::CollapsingHeader("Track FID File Names")) {
                UI::Indent();
                for (uint i = 0; i < musicTracksFidNames.Length; i++) {
                    UI::Text("[" + i + "] " + musicTracksFidNames[i]);
                }
                if (UI::Button("Search FID Tree for .ogg")) {
                    startnew(SearchForOggFiles);
                }
                UI::SameLine();
                if (UI::Button("Reset##ogg")) {
                    foundOggFiles.RemoveRange(0, foundOggFiles.Length);
                }
                if (foundOggFiles.Length > 0) {
                    if (UI::CollapsingHeader("Found .ogg Files")) {
                        UI::Indent();
                        for (uint i = 0; i < foundOggFiles.Length; i++) {
                            auto fof = foundOggFiles[i];
                            UI::Text("[" + i + "] " + fof.path);
                        }
                        UI::Unindent();
                    }
                }
                UI::Unindent();
            }
            UI::Text("AudioPort Sources Len: " + lastApSourcesLen);
            targetVolume = UI::SliderFloat("Target Volume", targetVolume, -100.0f, 20.0f);
            S_PrioritizeMusicInMap = UI::Checkbox("Prioritize Map Custom Music (when it exists)", S_PrioritizeMusicInMap);
            S_SetMusicInMapVolume = UI::Checkbox("Set Custom Music Volume", S_SetMusicInMapVolume);
            if (S_SetMusicInMapVolume) {
                S_MusicInMapVolume = UI::SliderFloat("Custom Music Volume", S_MusicInMapVolume, -100.0f, 20.0f);
                AddSimpleTooltip("dB; 0.0 is normal");
            }
        }
        UI::End();
    }

    void DrawPlayingVolumes() {
        if (UI::CollapsingHeader("Playing Volumes")) {
            UI::Indent();
            DrawPlayingVolumesInner();
            UI::Unindent();
        }
    }

    void DrawPlayingVolumesInner() {
        auto ap = GetApp().AudioPort;
        auto mtIxs = GetMTIsPlaying();
        for (uint i = 0; i < mtIxs.Length; i++) {
            auto ix = mtIxs[i];
            auto src = cast<CAudioSourceMusic>(ap.Sources[ix]);
            if (src is null) continue;
            UI::Text(tostring(ix) + ": " + GetTrackVolumesString(src));
        }
    }

    float[] volumesTmp;

    string GetTrackVolumesString(CAudioSourceMusic@ src) {
        volumesTmp.Resize(src.TracksVolume.Length);
        for (uint i = 0; i < src.TracksVolume.Length; i++) {
            volumesTmp[i] = src.TracksVolume[i];
        }
        return Json::Write(volumesTmp.ToJson());
    }

    uint[]@ GetMTIsPlaying() {
        uint[] mtis;
        for (uint i = 0; i < musicTrackIndexes.Length; i++) {
            if (musicTracksWerePlaying[i]) {
                mtis.InsertLast(musicTrackIndexes[i]);
            }
        }
        return mtis;
    }

    void SilenceMusics() {
        auto app = GetApp();
        auto audioPort = app.AudioPort;
        bool stale = SilenceCachedSources(audioPort);
        // once we have the first 2, we don't care about the rest (except editor)
        bool isInEditor = app.Editor !is null;
        uint maxTracks = isInEditor ? 3 : 2;
        if (stale && musicTrackIndexes.Length < 2) {
            FindMenuMusicSources(audioPort, true);
        }
    }

    // when we return stale, this is the last good index we found
    uint lastGoodIx = 0;

    void TrimMusicTrackIndexes(uint fromIx) {
        musicTrackIndexes.RemoveRange(fromIx, musicTrackIndexes.Length - fromIx);
        musicTracksWerePlaying.RemoveRange(fromIx, musicTracksWerePlaying.Length - fromIx);
        musicTracksFidNames.RemoveRange(fromIx, musicTracksFidNames.Length - fromIx);
    }

    bool SilenceCachedSources(CAudioPort@ ap) {
        bool stale = false;
        for (uint i = 0; i < musicTrackIndexes.Length; i++) {
            auto ix = musicTrackIndexes[i];
            if (ix >= ap.Sources.Length) {
                // some got cleared out, is okay for any indexes earlier than this
                TrimMusicTrackIndexes(i);
                break;
            }
            auto src = ap.Sources[ix];
            if (src.BalanceGroup != CAudioSource::EAudioBalanceGroup::Music) {
                // something changed but there are more sources. Remove higher indexes and break for re-find
                TrimMusicTrackIndexes(i);
                lastGoodIx = GetIxAfterLastKnown();
                stale = true;
                break;
            }
            SetVolumeOnSource(src, i);
        }
        if (lastApSourcesLen < ap.Sources.Length && !stale) {
            lastGoodIx = lastApSourcesLen;
            stale = true;
        } else if (lastApSourcesLen > ap.Sources.Length && !stale) {
            // something got removed, we need to re-find from last index
            lastGoodIx = GetIxAfterLastKnown();
            stale = true;
        }
        lastApSourcesLen = ap.Sources.Length;
        return stale;
    }

    void FindMenuMusicSources(CAudioPort@ ap, bool andSilence) {
        uint minIx = lastGoodIx;
        // print("GameMusic :: Finding music sources... (staring from " + minIx + ")");
        for (uint i = minIx; i < ap.Sources.Length; i++) {
            auto src = ap.Sources[i];
            if (src.BalanceGroup == CAudioSource::EAudioBalanceGroup::Music) {
                auto mtIx = musicTrackIndexes.Length;
                musicTrackIndexes.InsertLast(i);
                musicTracksWerePlaying.InsertLast(src.IsPlaying);
                musicTracksFidNames.InsertLast(GetSoundSourceFidName(src));
                if (andSilence) {
                    SetVolumeOnSource(src, mtIx);
                }
            }
        }
        // print("GameMusic :: Found " + musicTrackIndexes.Length + " music sources.");
    }

    void SetVolumeOnSource(CAudioSource@ src, uint mtIx) {
        // if we have in-game music, is it custom?
        bool isCustomInGameMusic = false; // Test(src);
        if (isCustomInGameMusic && S_PrioritizeMusicInMap) {
          src.VolumedB = S_SetMusicInMapVolume ? S_MusicInMapVolume : 3.0f;
        } else {
            src.VolumedB = targetVolume;
        }
        musicTracksWerePlaying[mtIx] = src.IsPlaying;
    }

    uint GetIxAfterLastKnown() {
        return musicTrackIndexes.Length > 0 ? musicTrackIndexes[musicTrackIndexes.Length - 1] + 1 : 0;
    }

    const string GetSoundSourceFidName(CAudioSource@ src) {
        try {
            auto fid = GetFidFromNod(src.PlugSound.PlugFile);
            return fid.FileName;
        } catch {
            warn("GameMusic :: Failed to get FID name for source. " + getExceptionInfo());
            return "Unknown";
        }
    }
}


#if TURBO

void SearchForOggFiles() {
    auto ap = GetApp().AudioPort;
    for (uint i = 0; i < ap.Sources.Length; i++) {
        auto src = ap.Sources[i];
        if (src.BalanceGroup == CAudioSource::EAudioBalanceGroup::Music) {
            try {
                auto fid = GetFidFromNod(src.PlugSound.PlugFile);
                print("Found source fid full path: " + Fids::GetFullPath(fid) + " | " + fid.FileName);
                print(Text::FormatPointer(Dev_GetPtrForNod(fid)));
                IO::SetClipboard(Text::FormatPointer(Dev_GetPtrForNod(fid)));
                FoundOggFile({}, fid);
            } catch {
                continue;
            }
        }
    }
    return;

    foundOggFiles.RemoveRange(0, foundOggFiles.Length);
    CSystemFidsFolder@ gameFolder = Fids::GetGameFolder("");
    Fids::UpdateTree(gameFolder, true);
    SearchForOggFiles(gameFolder);
    CSystemFidsFolder@ f2 = Fids::GetFakeFolder("");
    SearchForOggFiles(f2);
    SearchForOggFiles(Fids::GetProgramDataFolder(""));
}

void SearchForOggFiles(CSystemFidsFolder@ node) {
    SearchForOggFiles({}, node);
}
// we want to copy the array
void SearchForOggFiles(array<CSystemFidsFolder@> parents, CSystemFidsFolder@ node) {
    // print("Searching in " + FidsFolder_GetDirName(node));
    parents.InsertLast(node);
    auto treesLen = FidsFolder_TreesLen(node);
    auto leavesLen = FidsFolder_LeavesLen(node);
    for (uint i = 0; i < treesLen; i++) {
        SearchForOggFiles(parents, FidsFolder_GetTree(node, i));
    }
    for (uint i = 0; i < leavesLen; i++) {
        SearchForOggFiles(parents, FidsFolder_GetLeaf(node, i));
    }
}


uint FidsFolder_TreesLen(const CSystemFidsFolder@ folder) {
    return Dev::GetOffsetUint32(folder, 0x20 + 4);
}

uint FidsFolder_LeavesLen(const CSystemFidsFolder@ folder) {
    return Dev::GetOffsetUint32(folder, 0x14 + 4);
}

CSystemFidsFolder@ FidsFolder_GetTree(const CSystemFidsFolder@ folder, uint ix) {
    if (ix >= FidsFolder_TreesLen(folder)) {
        throw("Index out of range");
    }
    return cast<CSystemFidsFolder>(Dev::GetOffsetNod(Dev::GetOffsetNod(folder, 0x20), ix * 4));
}

CSystemFidFile@ FidsFolder_GetLeaf(const CSystemFidsFolder@ folder, uint ix) {
    if (ix >= FidsFolder_LeavesLen(folder)) {
        throw("Index out of range");
    }
    return cast<CSystemFidFile>(Dev::GetOffsetNod(Dev::GetOffsetNod(folder, 0x14), ix * 4));
}

string FidFile_GetFileName(const CSystemFidFile@ fid) {
    return Dev::GetOffsetString(fid, 0x88);
}

string FidsFolder_GetDirName(const CSystemFidsFolder@ folder) {
    return Dev::GetOffsetString(folder, 0x38);
}


// we don't want to copy the array this time
void SearchForOggFiles(array<CSystemFidsFolder@>@ parents, CSystemFidFile@ fid) {
    if (fid.FileName.EndsWith(".ogg")) {
        FoundOggFile(parents, fid);
    }
}

#else

void SearchForOggFiles() {
}

#endif


FoundOggFile@[] foundOggFiles;

class FoundOggFile {
    array<CSystemFidsFolder@>@ parents;
    CSystemFidFile@ fid;

    FoundOggFile(array<CSystemFidsFolder@>@ parents, CSystemFidFile@ fid) {
        @this.parents = parents;
        @this.fid = fid;
        Print();
        foundOggFiles.InsertLast(this);
        if (Dev::GetOffsetUint32(fid, 0xC) > 0) {
            print("xC_Nod Ptr: " + Text::FormatPointer(Dev::GetOffsetUint32(fid, 0xC)));
            auto xC_Nod = cast<CSystemFidsFolder>(Dev::GetOffsetNod(fid, 0xC));
            print("Found xC_Nod: " + (xC_Nod !is null ? string(xC_Nod.DirName) : "false"));
            if (xC_Nod !is null) {
                print("> " + xC_Nod.FullDirName);
            }
        }
    }

    string path;

    void Print() {
        if (path.Length == 0) {
            for (uint i = 0; i < parents.Length; i++) {
                path += parents[i].DirName + "/";
            }
            path += fid.FileName;
        }
        print("Found .ogg file: " + path);
    }
}
