#if SIG_DEVELOPER
uint64 Dev_GetPtrForNod(CMwNod@ nod) {
    if (nod is null) throw("null nod passed"); // return 0 here if you prefer, but remember to check it later!
    uint64 vtablePtr = Dev::GetOffsetUint64(nod, 0); // store the vtable ptr to restore later
    Dev::SetOffset(nod, 0, nod); // think about this from first principles if this doesn't make sense
    uint64 nodPtr = Dev::GetOffsetUint64(nod, 0); // read the nod ptr
    Dev::SetOffset(nod, 0, vtablePtr); // restore vtable ptr otherwise you will get a crash trying to do like anything with the nod
#if TURBO
    return uint64(uint32(nodPtr));
#endif
    return nodPtr; // ^_^
}
#endif



CAudioSource@ CAudioScriptSound_GetSource(CAudioScriptSound@ sound) {
    if (sound is null) return null;
    return cast<CAudioSource>(Dev::GetOffsetNod(sound, 0x20));
}
