namespace LittleWindow {
    [Setting hidden]
    bool S_ShowLittleWindow = false;
    bool S_ShowLittleWindowWhenOverlayHidden = true;
    bool S_ShowLittleWindowWhenGameUIHidden = true;

    void Render() {
        if (!S_ShowLittleWindow ||
            (!S_ShowLittleWindowWhenOverlayHidden && !UI::IsOverlayShown()) ||
            (!S_ShowLittleWindowWhenGameUIHidden && !UI::IsGameUIVisible())) {
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

    void RenderWindow_Inner() {
        auto pos = UI::GetCursorPos();
        auto music = Music::GetCurrentMusic();
        if (music !is null) {
            trackProg = "" + (music.GetCurrTrackIx() + 1) + " / " + music.origin.GetTrackCount();
            trackName = music.GetCurrTrackName();
            trackTime = music.GetTimeProgressString();
        }
        UI::Text(trackProg + " [ " + trackTime + " ] " + trackName);
    }
}
