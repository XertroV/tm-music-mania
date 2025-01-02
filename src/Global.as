namespace Global {
    //
    float _gameMusicVolume = 0.0;
    float _gameSoundsVolume = 0.0;
    bool IsMuteWhenUnfocused = false;
    bool IsGameFocused = false;

    void Update() {
        auto app = GetApp();
        CAudioPort@ ap = app.AudioPort;
        _gameMusicVolume = ap.MusicVolume;
        _gameSoundsVolume = ap.SoundVolume;
        // _gameMusicVolume = Math::InvLerp(-40.0, 0.0, Math::Clamp(ap.MusicVolume, -40.0, 0.0));
        // _gameMusicVolume = ConvertVolumeDbToAmp(_gameMusicVolume, vec2(-40.0, 0.0));
        IsMuteWhenUnfocused = ap.MuteWhenUnfocused;
        IsGameFocused = app.InputPort.IsFocused;
    }

    float get_MusicVolume() {
        return _gameMusicVolume;
    }

    void set_MusicVolume(float voldB) {
        GetApp().AudioPort.MusicVolume = voldB;
    }

    float get_GameVolume() {
        return _gameSoundsVolume;
    }

    void set_GameVolume(float voldB) {
        GetApp().AudioPort.SoundVolume = voldB;
    }

    [Setting hidden]
    float S_SavedMusicVolume = -5.0;
    [Setting hidden]
    float S_SavedGameVolume = -5.0;

    void SaveVolumes() {
        S_SavedMusicVolume = Global::MusicVolume;
        S_SavedGameVolume = Global::GameVolume;
    }

    void LoadVolumes() {
        Global::MusicVolume = S_SavedMusicVolume;
        Global::GameVolume = S_SavedGameVolume;
    }

    string get_SavedVolumeDescStr() {
        return Text::Format("M: %.1f dB", S_SavedMusicVolume)
            + Text::Format(", G: %.1f dB", S_SavedGameVolume);
    }

    void Draw_VolumeCheckboxes() {
        auto ap = GetApp().AudioPort;
        ap.MuteWhenUnfocused = UI::Checkbox("Mute when game unfocused", ap.MuteWhenUnfocused);
        // ap.SettingDisableDoppler = UI::Checkbox("Disable Doppler effect", ap.SettingDisableDoppler);
        // ap.SettingMaxSimultaneousSounds = UI::SliderInt("Max simultaneous sounds", ap.SettingMaxSimultaneousSounds, 48, 512);
    }
}

// openplanet is quite loud by default.
const float SCALE_VOL_FOR_OP = 0.325;

// The game volume is stored in decibels, need to convert to amplitude for openplanet.
// typical db range is -40 to 0
float ConvertVolumeDbToAmp(float volumeDb, vec2 &in minMaxVolumeDb) {
    volumeDb = Math::Clamp(volumeDb, minMaxVolumeDb.x, minMaxVolumeDb.y);
    // db = 20.0 * Math::Log10(amp);
    return Math::Pow(10.0, volumeDb / 20.0) * SCALE_VOL_FOR_OP;
}
