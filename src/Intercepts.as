void SetupIntercepts() {
    Dev::InterceptProc("CAudioScriptManager", "CreateSound", CAudioScriptManager_CreateSound);
    Dev::InterceptProc("CAudioScriptManager", "CreateSoundEx", CAudioScriptManager_CreateSoundEx);
    Dev::InterceptProc("CAudioScriptManager", "CreateMusic", CAudioScriptManager_CreateMusic);

}

bool CAudioScriptManager_CreateSound(CMwStack &in stack, CMwNod@ nod) {
    string url = stack.CurrentString(0);
    print("CAudioScriptManager::CreateSound: " + url);
    return true;
}

bool CAudioScriptManager_CreateSoundEx(CMwStack &in stack, CMwNod@ nod) {
    auto isSpatialized = stack.CurrentBool(0);
    bool isLooping = stack.CurrentBool(1);
    bool isMusic = stack.CurrentBool(2);
    float volumedB = stack.CurrentFloat(3);
    string url = stack.CurrentString(4);
    print("CAudioScriptManager::CreateSoundEx: " + url + " volumedB: " + volumedB + " isMusic: " + isMusic + " isLooping: " + isLooping + " isSpatialized: " + isSpatialized);
    return true;
}

bool CAudioScriptManager_CreateMusic(CMwStack &in stack, CMwNod@ nod) {
    string url = stack.CurrentString(0);
    print("CAudioScriptManager::CreateMusic: " + url);
    return true;
}
