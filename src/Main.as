const string PluginName = Meta::ExecutingPlugin().Name;
const string MenuIconColor = "\\$4f9";
const string PluginIcon = Icons::Headphones;
const string MenuTitle = MenuIconColor + PluginIcon + "\\$z " + PluginName;
const string MenuMainTitle = MenuIconColor + PluginIcon + "\\$z Music";

void Main() {
    startnew(SetupIntercepts);
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
    startnew(Turbo::Main).WithRunContext(Meta::RunContext::GameLoop);
    yield();
    startnew(Music::Main).WithRunContext(Meta::RunContext::GameLoop);
}

/** Called when the plugin is unloaded and completely removed from memory.
*/
void OnDestroyed() {
    // GameMusic::OnDestroyed();
    Turbo::OnDestroyed();
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
