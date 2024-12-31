namespace TM_State {
    bool IsMapNull;
	bool WasMapNull;
	// bool DidMapChange;
	bool IsInMenu;
	bool IsLoading;
	bool IsInSolo;
	bool IsInServer;
	bool IsInPlayground;
	bool IsInEditor;

	bool WasInMenu;
	bool WasLoading;
	bool WasInSolo;
	bool WasInServer;
	bool WasInPlayground;
	bool WasInEditor;

    bool ContextChanged;



	// void RenderEarly() {
    //     RunUpdate();
    // }

	void RunUpdate() {
		auto app = cast<CTrackMania>(GetApp());
		auto si = cast<CTrackManiaNetworkServerInfo>(app.Network.ServerInfo);

		WasMapNull = IsMapNull;
        WasInMenu = IsInMenu;
        WasLoading = IsLoading;
        WasInSolo = IsInSolo;
        WasInServer = IsInServer;
        WasInPlayground = IsInPlayground;
        WasInEditor = IsInEditor;

        IsLoading = int(app.LoadProgress.State) != 0; // 0 = Disabled
        IsInMenu = GetMenusFromSwitcher(app.Switcher) !is null;
		IsMapNull = app.RootMap is null;
		IsInEditor = app.Editor !is null;
		IsInPlayground = app.CurrentPlayground !is null;
		IsInSolo = IsInPlayground && app.PlaygroundScript !is null && si.ServerLogin.Length == 0;
		IsInServer = IsInPlayground && si.ServerLogin.Length > 0;

        ContextChanged = IsInEditor != WasInEditor || IsInPlayground != WasInPlayground || IsInSolo != WasInSolo || IsInServer != WasInServer || IsInMenu != WasInMenu || IsLoading != WasLoading || IsMapNull != WasMapNull;

        UpdatePlayground(app, cast<CSmArenaClient>(app.CurrentPlayground));

		// DidMapChange = false;
		// if (IsMapNull && !WasMapNull) {
		// 	lastMapUidValue = CurrMapUidValue;
		// 	CurrMapUidValue = 0;
		// 	DidMapChange = true;
		// 	CurrMapUid = "";
		// } else if (!IsMapNull) {
		// 	CheckUpdateMap(app.RootMap);
		// }
	}

    CTrackManiaMenus@ GetMenusFromSwitcher(CGameSwitcher@ switcher) {
        if (switcher.ModuleStack.Length == 0) {
            return null;
        }
        // 0 or Last-1, doesn't really make a difference.
        return cast<CTrackManiaMenus>(switcher.ModuleStack[switcher.ModuleStack.Length - 1]);
    }

    // SGamePlaygroundUIConfig::EUISequence / CGamePlaygroundUIConfig::EUISequence
    int InPg_LastUiSeq;
    // SGamePlaygroundUIConfig::EUISequence / CGamePlaygroundUIConfig::EUISequence
    int InPg_UiSeq;

    int InPg_GameTime;

    bool InPg_UiSeqChanged;
    bool InPg_InGameMenuDisplayed;

    void UpdatePlayground(CTrackMania@ app, CSmArenaClient@ curPg) {
        InPg_LastUiSeq = InPg_UiSeq;
        if (curPg is null) {
            InPg_UiSeq = 0;
        } else if (curPg.GameTerminals.Length == 0) {
            InPg_UiSeq = 0;
        } else {
            // InPg_UiSeq = int(curPg.GameTerminals[0].UISequence_Current);
            InPg_UiSeq = int(curPg.UIConfigs[0].UISequence);
            auto pgish = app.Network.PlaygroundInterfaceScriptHandler;
            InPg_GameTime = pgish.GameTime;
            InPg_InGameMenuDisplayed = pgish.IsInGameMenuDisplayed;
        }

        InPg_UiSeqChanged = InPg_UiSeq != InPg_LastUiSeq;
    }

    bool get_InPg_IsUiFinish() {
        return InPg_UiSeq == int(SGamePlaygroundUIConfig::EUISequence::Finish);
    }

    bool get_InPg_IsUiPlaying() {
        return InPg_UiSeq == int(SGamePlaygroundUIConfig::EUISequence::Playing);
    }

    bool get_InPg_IsUiPodium() {
        return InPg_UiSeq == int(SGamePlaygroundUIConfig::EUISequence::Podium);
    }

    bool get_InPg_IsUiIntro() {
        return InPg_UiSeq == int(SGamePlaygroundUIConfig::EUISequence::Intro);
    }

    bool get_InPg_IsUiEndRound() {
        return InPg_UiSeq == int(SGamePlaygroundUIConfig::EUISequence::EndRound);
    }

    bool get_InPg_IsUiNone() {
        return InPg_UiSeq == int(SGamePlaygroundUIConfig::EUISequence::None);
    }
}
