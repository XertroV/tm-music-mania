const string PluginName = Meta::ExecutingPlugin().Name;
const string MenuIconColor = "\\$f5d";
const string PluginIcon = Icons::Cogs;
const string MenuTitle = MenuIconColor + PluginIcon + "\\$z " + PluginName;

void Main() {
    startnew(SetupIntercepts);
    EnsureTurboAssets();
    CheckMp4AssetsAndRegister();
    CheckOldTmAssetsAndRegister();
    // a short break to give some time before starting music stuff on game start
    yield(10);
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

/** Render function called every frame intended only for menu items in `UI`.
*/
void RenderMenu() {
    GameMusic::RenderMenu();
    // TurboDebug::RenderMenu();
}
