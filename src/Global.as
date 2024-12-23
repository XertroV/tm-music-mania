namespace Global {
    float _gameMusicVolume = 1.0;

    void Update() {
        _gameMusicVolume = Math::InvLerp(-40.0, 0.0, Math::Clamp(GetApp().AudioPort.MusicVolume, -40.0, 0.0));
    }

    float get_MusicVolume() {
        return _gameMusicVolume;
    }
}
