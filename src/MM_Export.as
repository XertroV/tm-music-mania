/*


*/
#if FALSE

namespace MusicMania {
    void SetCustomMusic(const string &in playlistName, const string &in baseDir, const string[] &in files) {
        // todo: add a way for devs to force a reload
        // if the playlist exists, start it.
        auto ap = Packs::GetPack(playlistName);
        if (ap !is null) {
            trace("SetCustomMusic: starting playlist that already exists: " + playlistName);
            Music::SetCurrentMusicChoice(ap);
            return;
        }

        // check dir and paths
        string path = baseDir;
        if (path.StartsWith("file://")) {
            path = IO::FromAppFolder("GameData/" + path.SubStr(7));
        }

        string reqPrefix = IO::FromAppFolder("GameData/Media/");
        if (!path.StartsWith(reqPrefix)) throw("SetCustomMusic: baseDir must start with either `file://Media/` or `" + reqPrefix + "`. Instead, got " + baseDir);
        if (!IO::FolderExists(path)) throw("SetCustomMusic: folder does not exist: " + path);

        if (path.Contains("..")) throw("SetCustomMusic: baseDir contains '..': " + path);
        for (uint i = 0; i < files.Length; i++) {
            if (files[i].Contains("..")) throw("SetCustomMusic: file name contains '..': " + files[i]);
        }

        // add AudioPack and start
        path = path.Replace(reqPrefix, "file://Media/");
        // todo
        @ap = AudioPack_Playlist(playlistName, path, files, 0.0);
        Packs::AddPack(ap);
        Music::SetCurrentMusicChoice(ap, true);
    }
}


#endif
