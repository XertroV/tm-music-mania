const string PluginName = Meta::ExecutingPlugin().Name;
const string MenuIconColor = "\\$4f9";
const string MenuIconMutedColor = "\\$d44";
const string MenuIconQuietColor = "\\$f94";
const string PluginIcon = Icons::Headphones;
const string MenuTitle = MenuIconColor + PluginIcon + "\\$z " + PluginName;
const string MenuMainId = "mmusic";
const string MenuMainTitle = MenuIconColor + PluginIcon + "\\$z Music " + MenuIconColor + PluginIcon + "###" + MenuMainId;
const string MenuMainTitleMuted = MenuIconMutedColor + Icons::VolumeOff + "\\$z Music###" + MenuMainId;
const string MenuMainTitleVolMid = MenuIconQuietColor + Icons::VolumeDown + "\\$z Music###" + MenuMainId;


void Main() {
    startnew(SetupIntercepts);
    // keep track of all music
    Packs::AddPack(AudioPack_PlaylistEverything("<All>"));
    Packs::AddPack(AudioPack_PlaylistCustomDir("<Custom Music>"));
    Packs::AddPack(AudioPack_GameSounds_CustomDir("<Custom Game Sounds>"));
    // we start with TM2020 music
    Register_Tm2020_Assets();
    // download turbo assets by default
    EnsureTurboAssets();
    // check if we have these downloaded
    CheckMp4AssetsAndRegister();
    CheckOldTmAssetsAndRegister();
    CheckWiiAssetsAndRegister();
    CheckDsAssetsAndRegister();
    CheckVSAssetsAndRegister();

    // a short break to give some time before starting music stuff on game start
    yield(4);
    startnew(GameMusic::Main);
    yield();
    startnew(Music::Main).WithRunContext(Meta::RunContext::GameLoop);
}

/** Called when the plugin is unloaded and completely removed from memory.
*/
void OnDestroyed() {
    // GameMusic::OnDestroyed();
}

// seconds
float g_dt;

/** Called every frame. `dt` is the delta time (milliseconds since last frame).
*/
void Update(float dt) {
    g_dt = dt / 1000.0;
    Global::Update();
}

/** Render function called every frame intended for `UI`.
*/
void RenderInterface() {
    GameMusic::Render();
    // TurboDebug::Render();
}

/** Render function called every frame.
*/
void Render() {
    LittleWindow::Render();
}

/** Render function called every frame intended only for menu items in `UI`.
*/
void RenderMenu() {
    GameMusic::RenderMenu();
    // TurboDebug::RenderMenu();
}

/** Render function called every frame intended only for menu items in the main menu of the `UI`.
*/
void RenderMenuMain() {
    Music::RenderMenuMain();
}
