namespace LittleWindow {
    [Setting hidden]
    bool S_ShowLittleWindow = false;
    [Setting hidden]
    bool S_HideLittleWindowWhenOverlayHidden = false;
    [Setting hidden]
    bool S_HideLittleWindowWhenGameUIHidden = true;
    [Setting hidden]
    bool S_ShowNextButton = true;
    [Setting hidden]
    bool S_ShowTrackScrubber = true;
    [Setting hidden]
    bool S_ShowTrackPackInfo = true;
    [Setting hidden]
    bool S_ShowTrackInfo = true;
    [Setting hidden]
    bool S_DisableMarquee = false;

    void Render() {
        if (!S_ShowLittleWindow ||
            (S_HideLittleWindowWhenOverlayHidden && !UI::IsOverlayShown()) ||
            (S_HideLittleWindowWhenGameUIHidden && !UI::IsGameUIVisible())) {
            return;
        }

		UI::SetNextWindowSize(300, 0, UI::Cond::Appearing);
        if (UI::Begin("music-win", UI::WindowFlags::NoTitleBar | UI::WindowFlags::AlwaysAutoResize)) {
            RenderWindow_Inner();
        }
        UI::End();
    }

    string trackProg = "0 / 0";
    string trackName = "No track";
    string trackTime = "0:00 / 0:00";
    string packName = "No pack";

    void RenderWindow_Inner() {
        auto pos = UI::GetCursorPos();
        auto music = Music::GetCurrentMusic();
        CPlugSound@ mapMusic;
        CSystemPackDesc@ mapMusicDesc;
        CAudioSource@ mapMusicSrc;
        if (music !is null) {
            trackProg = "# " + (music.GetCurrTrackIx() + 1) + " / " + music.origin.GetTrackCount();
            trackName = music.GetCurrTrackName();
            trackTime = music.GetTimeProgressString();
            packName = music.GetOriginName();
        } else if (TM_State::IsInPlayground && TM_State::MapHasEmbeddedMusic) {
            @mapMusic = GetMapCustomMusic();
            @mapMusicDesc = GetMapCustomMusicPackDesc();
            @mapMusicSrc = GameMusic::TryGetMapMusicSource();
            trackProg = "# 1 / 1";
            trackName = GetClean_MusicPackDescName(mapMusicDesc.Name);
            packName = "<Current Map>";
            trackTime = GetMusicProgressString(mapMusicSrc, savedMapMusicCursor);
        }


        // UI::Text("\\$<\\$aaa" + trackProg + "\\$>  [ " + trackTime + " ]  \\$ccc" + trackName);
        if (S_ShowTrackPackInfo) {
            UI::Text(packName + "  \\$<\\$aaa" + trackProg + "\\$>");
        }
        if (S_ShowTrackInfo) {

            // marquee
            // t = Time::Now / frame_const
            // ss = Clamp(t - 24, 0, Len - 48)
            // EllipseTrim(name.SubStr(ss, 48 + 4))

            int len = trackName.Length;
            int maxLen = 48;
            if (len > maxLen) len += 3; // add three for initial "..."
            int t = int(Time::Now / 200) % len;
            int ss = Math::Clamp(t - maxLen*2/3, 0, Math::Max(0, len - maxLen));
            if (S_DisableMarquee) ss = 0;
            UI::Text("[ " + trackTime + " ]  \\$ccc" + EllipsisTrim((ss > 0 ? "..." : "") + trackName.SubStr(ss, maxLen + 3), maxLen));
            // UI::Text("ss: " + ss + "  t: " + t + "  len: " + len);
        }
        if (music is null && TM_State::MapHasEmbeddedMusic) {
            DrawMapMusicScrubber(mapMusicSrc);
        } else {
            DrawNextButton_Optional(cast<Music_StdTrackSelection>(music));
        }

        // helpers in case of issues with map music.
        if (TM_State::MapHasEmbeddedMusic) {
            if (!GameMusic::S_PrioritizeMusicInMap && Music::GetCurrentMusic() is null) {
                if (UX::SmallButton("Fix: Try and Play Chosen Music")) {
                    Music::ChooseInGameMusic();
                }
            } else if (GameMusic::S_PrioritizeMusicInMap && Music::GetCurrentMusic() !is null) {
                if (UX::SmallButton("Fix: Try and revert to Map Music")) {
                    Music::ChooseInGameMusic();
                }
            }
        }
    }

    vec2 savedMapMusicCursor;

    void DrawMapMusicScrubber(CAudioSource@ src) {
        if (src is null || !S_ShowTrackScrubber) {
            return;
        }
        UX::PushThinControls();
        float _indent = 4.0;
        UI::Indent(_indent);

        if (S_ShowNextButton) {
            if (UX::SmallButton(src.IsPlaying ? Icons::Pause : Icons::Play)) {
                startnew(CoroutineFuncUserdata(ToggleSourcePlaying), src);
            }
            UI::SameLine();
        }

        vec2 avail = UI::GetContentRegionAvail();
        float w = avail.x / UI::GetScale() - _indent;

        UI::SetNextItemWidth(Math::Max(w, 60.));
        // src.DrawPlayCursorSlider();
        UX::PlayCursorSlider(src, "##map-m-cur", savedMapMusicCursor);
        if (UI::IsItemClicked(UI::MouseButton::Right)) {
            ToggleSourcePlaying(src);
        }

        UI::Unindent(_indent);
        UX::PopThinControls();
    }

    void ToggleSourcePlaying(ref@ _src) {
        auto src = cast<CAudioSource>(_src);
        if (src.IsPlaying) {
            savedMapMusicCursor.x = src.PlayCursor;
            savedMapMusicCursor.y = src.PlayCursorUi;
            src.Stop();
        } else {
            src.Play();
            src.PlayCursor = savedMapMusicCursor.x;
            src.PlayCursorUi = savedMapMusicCursor.y;
        }
    }

    float _nextButtonW = 40.;

    void DrawNextButton_Optional(Music_StdTrackSelection@ music) {
        // to avoid doing anything to UI
        if (!S_ShowNextButton && !S_ShowTrackScrubber) {
            return;
        }

        if (music is null) {
            return;
        }

        float _indent = 4.0;

        UX::PushThinControls();
        UI::Indent(_indent);

        if (S_ShowNextButton) {
            auto sound = music.GetCurrMusic();
            if (sound !is null) {
                if (UX::SmallButton(sound.IsPlaying ? Icons::Pause : Icons::Play)) {
                    startnew(CoroutineFunc(music.TryPlayPause));
                }
                UI::SameLine();
            }
            if (UX::SmallButton(Icons::StepForward + " Next")) {
                music.On_NextTrack();
            }
            UI::SameLine();
        }

        vec2 avail;
        bool wasRightClicked = false;
        if (S_ShowTrackScrubber) {
            avail = UI::GetContentRegionAvail();
            auto source = music.GetCurrMusicSource();

            if (source !is null) {
                float w = avail.x / UI::GetScale() - _indent;
                UI::SetNextItemWidth(Math::Max(w, 60.));
                music.DrawPlayCursorSlider();
                wasRightClicked = UI::IsItemClicked(UI::MouseButton::Right);
            } else {
                UI::Dummy(vec2());
            }
        }

        if (wasRightClicked) {
            music.TryPlayPause();
        }


        UI::Unindent(_indent);
        UX::PopThinControls();

        if (Global::IsMutedBecauseUnfocused) {
            UI::Text("\\$i\\$999Muted - Game not focused");
        }
    }

    string GetMusicProgressString(CAudioSource@ src, vec2 playCursorIfPaused = vec2()) {
        if (src is null) {
            return "0:00 / 0:00";
        }
        bool isPaused = !src.IsPlaying && playCursorIfPaused.x > 0;
        float sec = isPaused ? playCursorIfPaused.x : src.PlayCursor;
        float denom = isPaused ? playCursorIfPaused.y : (src.PlayCursorUi > 0.0 ? src.PlayCursorUi : 1.0);
        float dur = sec / denom;
        return Time::Format(int64(sec * 1000.), false, true, false, true) + " / " + Time::Format(int64(dur * 1000.), false, true, false, true);
    }
}

// get leaf and remove mux extension
string GetClean_MusicPackDescName(const string &in _name) {
    string name = _name;
    auto parts = name.Replace("\\", "/").Split("/");
    if (parts.Length > 1) {
        name = parts[parts.Length - 1];
    }
    if (name.EndsWith(".mux")) {
        name = name.SubStr(0, name.Length - 4);
    }
    return name;
}
