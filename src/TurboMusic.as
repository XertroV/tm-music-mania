TurboMusic@ ReadTurboMusicFromDirectory(const string &in path) {
    return TurboMusic(path);
}


Meta::PluginCoroutine@ tmusictest = startnew(TMusicTest);

TurboMusic@ g_turboMusic;
string[]@ g_turboMusicPaths;

string[]@ TurboMusicPaths() {
    auto dir = "C:/Users/xertrov/OpenplanetTurbo/Extract/Media/Sounds/TMConsole/Loops";
    auto files = IO::IndexFolder(dir, false);
    string[] paths;
    for (uint i = 0; i < files.Length; i++) {
        if (files[i].EndsWith("/")) {
            paths.InsertLast(GetLastDirName(files[i]));
        }
    }
    print("Found " + paths.Length + " TurboMusic paths; " + Json::Write(paths.ToJson(), true));
    return paths;
}

void TMusicTest() {
    @g_turboMusicPaths = TurboMusicPaths();
    LoadRandomTurboMusic();
}

void LoadRandomTurboMusic() {
    if (g_turboMusic !is null) g_turboMusic.StopAll();
    @g_turboMusic = TurboMusic("C:/Users/xertrov/OpenplanetTurbo/Extract/Media/Sounds/TMConsole/Loops/" + g_turboMusicPaths[Math::Rand(0, g_turboMusicPaths.Length)]);
}


class NamedSample {
    Audio::Sample@ sample;
    string name;
    int intensity;
    TurboMusicLayer@ layer;

    NamedSample(Audio::Sample@ s, const string &in name, int intensity) {
        @sample = s;
        this.name = name;
        this.intensity = intensity;
        @layer = TurboMusicLayer(this, 1.0, MusicFading::FadeIn, false);
    }

}


class TurboMusic : Music {
    string turboDirPath;

    NamedSample@ sLap;
    NamedSample@ sFreewheel;
    NamedSample@[] sLoop;

    TurboMusic(const string &in path) {
        turboDirPath = path.Replace("\\", "/");
        auto pathParts = turboDirPath.Split("/");
        // name is the last part of the path
        super(pathParts[pathParts.Length - 1]);
        LoadXML(turboDirPath + "/settings.xml");
        print("Loaded TurboMusic: " + path);
        PrintJson();
        yield();
        // PlayAll();
        StartPlaying();
    }


    NamedSample@ LoadSample(const string &in audioName, int intensity) {
        auto fullPath = turboDirPath + "/Tracks/" + audioName + ".ogg";
        if (!IO::FileExists(fullPath)) {
            warn("File does not exist: " + fullPath);
            return null;
        }
        print("Loading sample: " + fullPath);
        Audio::Sample@ s = Audio::LoadSample(ReadFileToBuf(fullPath), false);
        // auto v = Audio::Play(s, 0.5);
        // sleep(v.GetLength() * 1000);
        return NamedSample(s, audioName, intensity);
    }

    void StopAll() {
        for (uint i = 0; i < layers.Length; i++) {
            layers[i].voice.SetGain(0.0);
        }
        IsPlaying = false;
    }

    void LoadXML(const string &in xmlPath) {
        XML::Document@ doc = XML::Document(ReadFileToString(xmlPath));
        XML::Node root = doc.Root();
        auto music = root.Child("music");
        auto mChild = music.FirstChild();
        while (mChild) {
            ParseMusicChild(mChild);
            mChild = mChild.NextSibling();
        }
    }

    void ParseMusicChild(XML::Node &in node) {
        auto name = node.Name();
        if (name == "segment") ParseSegmentNode(node);
        else if (name == "tempo") ParseTempoNode(node);
        else warn("Unknown node: " + name);
    }

    // beats per minute
    float bpm;
    // seconds per beat
    float spb;
    // beats per bar
    float bpb;

    float get_CrossfadeDuration() {
        return (bpm / 60.0 * 4.0) * 0.5;
    }

    void ParseTempoNode(XML::Node &in node) {
        bpm = Text::ParseFloat(node.Attribute("beatsperminute"));
        bpb = Text::ParseFloat(node.Attribute("beatsperbar"));
        spb = 60.0 / bpm;
    }

    void ParseSegmentNode(XML::Node &in node) {
        auto name = node.Attribute("name");
        print("Segment: " + name);
        if (name == "loop") ParseSegmentLoopNode(node);
        else if (name == "lap") ParseSegmentLapNode(node);
        else if (name == "freewheel") ParseSegmentFreewheelNode(node);
        else warn("Unknown segment: " + name);
    }

    string lapVariantName;
    int lapVariantIntensity;

    void ParseSegmentLapNode(XML::Node &in node) {
        auto tg = node.Child("trackgroup");
        auto var = tg.Child("variant");
        lapVariantName = var.Attribute("name");
        lapVariantIntensity = Text::ParseInt(var.Attribute("intensity"));
        @sLap = this.LoadSample(lapVariantName, lapVariantIntensity);
    }

    string freewheelVariantName;
    int freewheelVariantIntensity;

    void ParseSegmentFreewheelNode(XML::Node &in node) {
        auto tg = node.Child("trackgroup");
        auto var = tg.Child("variant");
        freewheelVariantName = var.Attribute("name");
        freewheelVariantIntensity = Text::ParseInt(var.Attribute("intensity"));
        @sFreewheel = this.LoadSample(freewheelVariantName, freewheelVariantIntensity);
    }

    uint loopVariantMaxCycles;
    string loopVariantOrder;

    void ParseSegmentLoopNode(XML::Node &in node) {
        loopVariantMaxCycles = Text::ParseUInt(node.Attribute("variant_maxcycles"));
        auto tg = node.Child("trackgroup");
        loopVariantOrder = tg.Attribute("variant_order");
        ParseTrackGroup(tg);
    }

    TGVariant[] trackGroupVariants;
    int minIntensity = 999;
    int maxIntensity = -1;

    void ParseTrackGroup(XML::Node &in node) {
        auto child = node.FirstChild();
        string name;
        while (child) {
            name = child.Name();
            if (name == "variant") {
                trackGroupVariants.InsertLast(TGVariant(child));
                auto @var = trackGroupVariants[trackGroupVariants.Length - 1];
                if (var.intensity < minIntensity) minIntensity = var.intensity;
                if (var.intensity > maxIntensity) maxIntensity = var.intensity;
                auto ns = this.LoadSample(var.name, var.intensity);
                if (ns !is null) {
                    sLoop.InsertLast(ns);
                } else {
                    trackGroupVariants.RemoveLast();
                }
            } else {
                warn("Unknown trackgroup child: " + name);
            }
            child = child.NextSibling();
        }
        print("Min intensity: " + minIntensity);
        print("Max intensity: " + maxIntensity);
    }

    void PrintNode(XML::Node &in node, int depth = 0) {
        print(SPACE_PAD.SubStr(0, depth*2) + "- " + node.Name());
        auto child = node.FirstChild();
        while (child) {
            PrintNode(child, depth + 1);
            child = child.NextSibling();
        }
    }

    Json::Value@ ToJson() {
        auto @root = Json::Object();
        root["name"] = name;
        root["bmp"] = bpm;
        root["bpb"] = bpb;
        auto @segments = Json::Array();
        for (uint i = 0; i < trackGroupVariants.Length; i++) {
            auto variant = Json::Object();
            variant["name"] = trackGroupVariants[i].name;
            variant["intensity"] = trackGroupVariants[i].intensity;
            variant["subgroups"] = trackGroupVariants[i].subgroups;
            segments.Add(variant);
        }

        auto @freewheelSegment = Json::Object();
        freewheelSegment["name"] = freewheelVariantName;
        freewheelSegment["intensity"] = freewheelVariantIntensity;
        auto @lapSegment = Json::Object();
        lapSegment["name"] = lapVariantName;
        lapSegment["intensity"] = lapVariantIntensity;

        root["segments"] = segments;
        root["freewheel"] = freewheelSegment;
        root["lapSegment"] = lapSegment;

        return root;
    }

    void PrintJson() {
        print(Json::Write(this.ToJson(), true));
    }




    void Debug_PlayAll() {
        for (uint i = 0; i < sLoop.Length; i++) {
            WaitTillDone(Audio::Play(sLoop[i].sample, 0.5));
        }
        auto v = Audio::Play(sFreewheel.sample, 0.5);
        WaitTillDone(v);
        @v = Audio::Play(sLap.sample, 0.5);
        WaitTillDone(v);
    }




    void StartPlaying() {
        startnew(CoroutineFunc(this.PlayLoop)).WithRunContext(MUSIC_RUN_CTX);
    }

    TurboMusicLayer@[] layers;

    int currIntensity = 0;
    // probability we will swap to a new variant
    float swapVariantP = .5;

    bool IsPlaying = false;

    void PlayLoop() {
        IsPlaying = true;
        currIntensity = minIntensity;
        swapVariantP = 2.0 / loopVariantMaxCycles;

        while (IsPlaying) {
            if (layers.Length == 0) {
                FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration);
            } else {
                CheckForDoneLayersAndUpdate();
            }
            yield();
        }
    }


    bool FindAndPlayVariant(int intensity, MusicFading fade, float cfDuration, const string &in nameNot = "", float pos = 0.0) {
        print("FindAndPlayVariant: " + intensity + " fade: " + fade + " cfDuration: " + cfDuration + " nameNot: " + nameNot);

        auto varDist = 0;
        auto namedSample = FindVariant(intensity, varDist, nameNot);
        while (namedSample is null && varDist < 5) @namedSample = FindVariant(intensity, ++varDist, nameNot);
        if (namedSample is null) {
            warn("No variant found for intensity: " + intensity);
            return false;
        }
        print("Playing variant: " + namedSample.name);
        // layers.InsertLast(TurboMusicLayer(namedSample, cfDuration, fade));
        layers.InsertLast(namedSample.layer);
        namedSample.layer.ResetFadeIn(pos);
        // currIntensity = namedSample.intensity;
        return true;
    }

    NamedSample@ FindVariant(int intensity, int dist, const string &in nameNot = "") {
        uint startIx = Math::Rand(0, sLoop.Length - 1);
        uint modIx = sLoop.Length;
        for (uint i = 0; i < trackGroupVariants.Length; i++) {
            uint ix = (startIx + i) % modIx;
            if (Math::Abs(trackGroupVariants[ix].intensity - intensity) <= dist && trackGroupVariants[ix].name != nameNot && !sLoop[ix].layer.IsPlaying) {
                return sLoop[ix];
            }
        }
        if (Math::Abs(lapVariantIntensity - intensity) <= dist && lapVariantName != nameNot && !sLap.layer.IsPlaying) {
            return sLap;
        }
        if (Math::Abs(freewheelVariantIntensity - intensity) <= dist && freewheelVariantName != nameNot && !sFreewheel.layer.IsPlaying) {
            return sFreewheel;
        }
        return null;
    }

    void UpdateIntensity() {
        auto p = VehicleState::GetViewingPlayer();
        if (p is null) return;
        auto v = VehicleState::GetVis(GetApp().GameScene, p);
        if (v is null) return;
        currIntensity = int(Math::Round(Math::Lerp(float(minIntensity), float(maxIntensity), Math::Clamp(Math::InvLerp(100.0, 500.0, 3.6*v.AsyncState.FrontSpeed), 0.0, 1.0))));
    }

    int trackUpperLim = 2;
    bool doneFirst = false;

    void CheckForDoneLayersAndUpdate() {
        UpdateIntensity();
        if (layers.Length == 0) return;

        float pos = layers[0].voice.GetPosition();
        float len = layers[0].voice.GetLength();
        bool l0Done = layers[0].IsDone;
        if (l0Done) pos = layers[0].lastPosDelta - layers[0].finalPartial;

        IsOnBeat = Math::Abs(((pos + g_dt * .5) % spb)) < g_dt;

        if (!doneFirst && l0Done) {
            doneFirst = true;
            FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration, layers[layers.Length - 1].name, pos);
        }

        for (int i = layers.Length - 1; i >= 0; i--) {
            if (i > 0 && Math::Abs(layers[i].voice.GetPosition() - pos) > 0.015) {
                layers[i].SetPosition(pos);
            }
            if (layers[i].Update()) {
                auto @layer = layers[i];
                print("Layer done: " + layer.name);
                layers.RemoveAt(i);
                switch (layer.fade) {
                    // FadeIn: repeat
                    // None: repeat
                    //    - but if it's the only one, a chance to swap to a new variant (which means fade out and add new variant)
                    // FadeOut: remove
                    case MusicFading::FadeIn:
                        layer.ResetNoFade(pos);
                        layers.InsertLast(layer);
                        trace("Repeating layer (faded in): " + layer.name);
                        break;
                    case MusicFading::None: {
                        bool hasRoom = layers.Length < trackUpperLim;
                        // layer.Repetitions < loopVariantMaxCycles
                        if (hasRoom && Math::Rand(.0, 1.0) < swapVariantP) {
                            trace("Swapping variant: " + layer.name);
                            layer.ResetFadeOut(pos);
                            layers.InsertLast(layer);
                            FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration, layer.name, pos);
                        } else if (currIntensity == layer.intensity || layers.Length == 0) {
                            trace("Repeating layer: " + layer.name);
                            layer.ResetNoFade(pos);
                            layers.InsertLast(layer);
                        } else {
                            layer.ResetFadeOut(pos);
                            layers.InsertLast(layer);
                            print("layers.Length: " + layers.Length);
                            print("currIntensity: " + currIntensity + " layer.intensity: " + layer.intensity);
                            print("Dropping layer: " + layer.name);
                            if (layers.Length == 1) {
                                FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration, layer.name, pos);
                            }
                        }

                        if (layers.Length < trackUpperLim - 1 && Math::Rand(.0, 1.0) < swapVariantP) {
                            FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration, layer.name, pos);
                        }
                        break;
                    }
                    case MusicFading::FadeOut:
                        // layer.voice.Pause();
                        layer.NullifyVoice();
                        // layer.voice.SetPosition(0.0);
                        break;
                }
            }
        }


        bool allFadingOut = true;
        for (uint i = 0; i < layers.Length; i++) {
            if (!layers[i].IsFadingOut) {
                allFadingOut = false;
                break;
            }
        }
        if (allFadingOut) {
            layers[0].ResetNoFade(pos);
            FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration, layers[0].name, pos);
        }

        float firstPos = layers[0].voice.GetPosition();
        if (firstPos < 0.01) {
            bool anyCorrectIntensity = false;
            for (uint i = 0; i < layers.Length; i++) {
                if (layers[i].intensity == currIntensity) {
                    anyCorrectIntensity = true;
                    break;
                }
            }
            if (!anyCorrectIntensity) {
                layers[0].ResetFadeOut(pos);
                FindAndPlayVariant(currIntensity, MusicFading::FadeIn, CrossfadeDuration * .2, "", pos);
            }

            for (uint i = 1; i < layers.Length; i++) {
                layers[i].SetPosition(firstPos);
            }
        }

    }

    bool IsOnBeat;
}

enum MusicFading {
    None,
    FadeIn,
    FadeOut
}

class TurboMusicLayer {
    NamedSample@ s;
    Audio::Sample@ sample;
    Audio::Voice@ voice;
    string name;
    float crossfadeDuration;
    bool isFadingOut;
    // crossfade progress [0, 1], start, end
    float cfP, cfStart, cfEnd;
    vec2 volStartEnd;
    float currVol;
    int intensity;
    float duration;
    float progress;
    float Repetitions;

    ~TurboMusicLayer() {
        print("Destroying TurboMusicLayer: " + name);
        if (voice !is null) {
            voice.SetGain(0.0);
            @voice = null;
        }
    }


    TurboMusicLayer(NamedSample@ s, float crossfadeDuration = 1.0, MusicFading fade = MusicFading::FadeIn, bool playImmediately = true) {
        @this.s = s;
        @this.sample = s.sample;
        this.name = s.name;
        this.intensity = s.intensity;
        this.crossfadeDuration = crossfadeDuration;
        this.cfP = crossfadeDuration > 0.0 ? 0.0 : 1.0;
        this.cfStart = 0.0;
        this.cfEnd = crossfadeDuration;
        this.fade = fade;
        switch (fade) {
            case MusicFading::FadeIn:
                volStartEnd.x = 0.0;
                volStartEnd.y = 1.0;
                break;
            case MusicFading::FadeOut:
                volStartEnd.x = 1.0;
                volStartEnd.y = 0.0;
                break;
            default:
                volStartEnd = vec2(1.0);
                break;
        }
        currVol = volStartEnd.x;
        SetVoiceUpdateAndStart(playImmediately);

        if (fade == MusicFading::FadeOut) {
            cfEnd = voice.GetLength();
            cfStart = cfEnd - crossfadeDuration;
        }
    }

    void SetPosition(float pos) {
        trace("["+name+"] SetPosition: " + pos + " / " + (voice !is null));
        if (voice is null) return;
        // pos += g_dt
        voice.SetPosition(Math::Max(pos, 0.0) + 0.01);
    }

    void SetVoiceUpdateAndStart(bool andStart = true) {
        Update();
        SetVoice();
        if (andStart) StartVoice();
    }

    void NullifyVoice() {
        if (voice !is null) {
            voice.SetGain(0.0);
            @voice = null;
        }
    }

    void SetVoice() {
        // if (voice is null)
        NullifyVoice();
        @this.voice = Audio::Start(this.sample);
        voice.SetGain(currVol * Global::MusicVolume);
        duration = voice.GetLength();
        crossfadeDuration = duration * 0.7;
    }

    void StartVoice() {
        voice.SetGain(currVol * Global::MusicVolume);
        if (voice.IsPaused()) voice.Play();
    }

    void StartIfNotPlaying() {
        if (voice.IsPaused()) {
            voice.Play();
        }
    }

    void OptionallyReplaceVoice() {
        if (IsDone) {
            SetVoice();
        }
    }

    bool get_IsPlaying() {
        return voice !is null && !voice.IsPaused();
    }

    void ResetFadeIn(float pos) {
        cfP = 0.0;
        fade = MusicFading::FadeIn;
        volStartEnd = vec2(0.0, 1.0);
        currVol = 0.0;
        cfStart = 0.0;
        cfEnd = crossfadeDuration;
        SetVoice();
        SetPosition(pos);
        StartIfNotPlaying();
        Repetitions++;
        // print("ResetFadeIn: " + newPos);
    }

    void ResetNoFade(float pos) {
        cfP = 1.0;
        fade = MusicFading::None;
        volStartEnd = vec2(1.0);
        currVol = 1.0;
        cfStart = 0.0;
        cfEnd = crossfadeDuration;
        SetVoice();
        StartIfNotPlaying();
        SetPosition(pos);
        Repetitions++;
        // print("ResetNoFade: " + newPos);
    }

    void ResetFadeOut(float pos) {
        cfP = 0.0;
        fade = MusicFading::FadeOut;
        volStartEnd = vec2(1.0, 0.0);
        currVol = 1.0;
        SetVoice();
        SetPosition(pos);
        StartIfNotPlaying();
        cfStart = duration - crossfadeDuration;
        cfEnd = duration;
        Repetitions = 0;
        print("ResetFadeOut: " + pos + " / " + duration + " CF " + cfStart + " -> " + cfEnd);
    }

    MusicFading fade;
    bool IsFadingOut {
        get { return fade == MusicFading::FadeOut; }
    }

    float finalPartial, lastPosDelta, remaining, lastPos;

    // returns true if done
    bool Update(bool noDt = false) {
        if (cfP < 1.0) {
            // cfP = Math::Clamp(cfP + (noDt ? 0.0 : g_dt) / crossfadeDuration, 0.0, 1.0);
            if (voice !is null && voice.GetPosition() >= cfStart) {
                cfP = Math::Clamp(cfP + (noDt ? 0.0 : g_dt) / crossfadeDuration, 0.0, 1.0);
            }
            currVol = Math::Lerp(volStartEnd.x, volStartEnd.y, EasedCfProgress());
        }
        progress += noDt ? 0.0 : g_dt;
        if (voice !is null) {
            voice.SetGain(currVol * Global::MusicVolume);
        }
        if (IsDone) {
            finalPartial = voice.GetPosition() - lastPos;
        } else if (voice !is null) {
            lastPosDelta = voice.GetPosition() - lastPos;
            remaining = voice.GetLength() - voice.GetPosition();
            lastPos = voice.GetPosition();
        }
        return IsDone;
    }

    bool get_IsDone() {
        return voice !is null && voice.GetPosition() >= voice.GetLength();
    }

    float EasedCfProgress() {
        return QuadInOut(cfP);
    }
}


float QuadInOut(float t) {
    return t < 0.5 ? 2.0 * t * t : 1.0 - Math::Pow(-2.0 * t + 2.0, 2.0) / 2.0;
}

float LinearInOut(float t) {
    return t;
}


class TGVariant {
    string name;
    int intensity;
    int subgroups;
    TGVariant() {}
    TGVariant(XML::Node &in node) {
        name = node.Attribute("name");
        intensity = Text::ParseInt(node.Attribute("intensity"));
        subgroups = Text::ParseInt(node.Attribute("subgroups"));
    }
    TGVariant(const string &in name, int intensity, int subgroups) {
        this.name = name;
        this.intensity = intensity;
        this.subgroups = subgroups;
    }
}

const string SPACE_PAD = "           ";



string ReadFileToString(const string &in path) {
    try {
        IO::File file(path, IO::FileMode::Read);
        return file.ReadToEnd();
    } catch {
        warn("Failed to read file: " + path);
        warn("Error: " + getExceptionInfo());
    }
    return "";
}

MemoryBuffer@ ReadFileToBuf(const string &in path) {
    try {
        IO::File file(path, IO::FileMode::Read);
        return file.Read(file.Size());
    } catch {
        warn("Failed to read file: " + path);
        warn("Error: " + getExceptionInfo());
    }
    return null;
}

void WaitTillDone(Audio::Voice@ v) {
    while (v.GetPosition() < v.GetLength()) {
        yield();
    }
}


string GetLastDirName(string path) {
    path = path.Replace("\\", "/");
    while (path.EndsWith("/")) path = path.SubStr(0, path.Length - 1);
    auto parts = path.Split("/");
    return parts[parts.Length - 1];
}





namespace TurboDebug {
    bool window = true;

    bool IsTurboMusicOnBeat() {
        if (g_turboMusic is null) return false;
        return g_turboMusic.IsOnBeat;
    }

    void RenderMenu() {
        auto frameBgActive = UI::GetStyleColor(UI::Col::FrameBg);
        if (IsTurboMusicOnBeat()) frameBgActive = vec4(0.0, 1.0, 0.0, 1.0);
        UI::PushStyleColor(UI::Col::FrameBg, frameBgActive);
        if (UI::MenuItem("TurboMusic Debug", "", window)) {
            window = !window;
        }
        UI::PopStyleColor();
    }

    void Render() {
        if (!window) return;
        if (UI::Begin("TurboMusic Debug", window)) {
            RenderInner();
        }
        UI::End();
    }

    void RenderInner() {
        if (g_turboMusic is null) {
            UI::Text("No TurboMusic loaded");
            return;
        }
        if (UI::Button("Randomize Music")) {
            startnew(LoadRandomTurboMusic);
        }
        if (UI::Button("Play All")) {
            g_turboMusic.Debug_PlayAll();
        }
        UI::SameLine();
        if (UI::Button("Start Playing")) {
            g_turboMusic.StartPlaying();
        }
        UI::SameLine();
        if (UI::Button("Stop Playing")) {
            g_turboMusic.IsPlaying = false;
        }
        if (UI::Button("+ Intensity")) {
            g_turboMusic.currIntensity = Math::Min(g_turboMusic.currIntensity + 1, g_turboMusic.maxIntensity);
        }
        UI::SameLine();
        if (UI::Button("- Intensity")) {
            g_turboMusic.currIntensity = Math::Max(g_turboMusic.currIntensity - 1, g_turboMusic.minIntensity);
        }


        UI::Text("Name: " + g_turboMusic.name);
        UI::Text("Layers: " + g_turboMusic.layers.Length);
        UI::Text("Curr Intensity: " + g_turboMusic.currIntensity);
        for (uint i = 0; i < g_turboMusic.layers.Length; i++) {
            UI::Text("Layer " + i);
            UI::Indent();
            UI::Text("Name: " + g_turboMusic.layers[i].name);
            UI::Text("Intensity: " + g_turboMusic.layers[i].intensity);
            UI::Text("Fading: " + g_turboMusic.layers[i].fade);
            UI::Text("Position: " + Text::Format("%.6f", g_turboMusic.layers[i].voice.GetPosition()));
            UI::Text("Length: " + g_turboMusic.layers[i].voice.GetLength());
            UI::Text("IsDone: " + g_turboMusic.layers[i].IsDone);
            auto v = g_turboMusic.layers[i].voice;
            if (v !is null) {
                UI::Text("Gain: " + v.GetGain());
                UI::Text("Pos > Len: " + (v.GetPosition() > v.GetLength()));
            }
            UI::Text("cfP: " + g_turboMusic.layers[i].cfP);
            UI::SliderFloat("CurrVol", g_turboMusic.layers[i].currVol, 0.0, 1.0);
            UI::Unindent();
        }
    }
}
