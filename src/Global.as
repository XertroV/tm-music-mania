namespace Global {
    //
    float _gameMusicVolume = 0.0;
    bool IsMuteWhenUnfocused = false;
    bool IsGameFocused = false;

    void Update() {
        auto app = GetApp();
        CAudioPort@ ap = app.AudioPort;
        _gameMusicVolume = ap.MusicVolume;
        // _gameMusicVolume = Math::InvLerp(-40.0, 0.0, Math::Clamp(ap.MusicVolume, -40.0, 0.0));
        // _gameMusicVolume = ConvertVolumeDbToAmp(_gameMusicVolume, vec2(-40.0, 0.0));
        IsMuteWhenUnfocused = ap.MuteWhenUnfocused;
        IsGameFocused = app.InputPort.IsFocused;
    }

    // openplanet scale; 0.0 to 1.0
    float get_MusicVolume() {
        if (IsMuteWhenUnfocused && !IsGameFocused) {
            return 0.0;
        }
        return _gameMusicVolume;
    }

    void set_MusicVolume(float voldB) {
        GetApp().AudioPort.MusicVolume = voldB;
    }

    float get_GameVolume() {
        return GetApp().AudioPort.SoundVolume;
    }

    void set_GameVolume(float voldB) {
        GetApp().AudioPort.SoundVolume = voldB;
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
