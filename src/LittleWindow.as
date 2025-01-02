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
        if (music !is null) {
            trackProg = "# " + (music.GetCurrTrackIx() + 1) + " / " + music.origin.GetTrackCount();
            trackName = music.GetCurrTrackName();
            trackTime = music.GetTimeProgressString();
            packName = music.GetOriginName();
        }
        // UI::Text("\\$<\\$aaa" + trackProg + "\\$>  [ " + trackTime + " ]  \\$ccc" + trackName);
        if (S_ShowTrackPackInfo) {
            UI::Text(packName + "  \\$<\\$aaa" + trackProg + "\\$>");
        }
        if (S_ShowTrackInfo) {
            UI::Text("[ " + trackTime + " ]  \\$ccc" + trackName);
        }
        DrawNextButton_Optional(cast<Music_StdTrackSelection>(music));
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
}
