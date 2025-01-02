void AddSimpleTooltip(const string &in msg) {
	if (UI::IsItemHovered()) {
		UI::SetNextWindowSize(400, 0, UI::Cond::Appearing);
		UI::BeginTooltip();
		UI::TextWrapped(msg);
		UI::EndTooltip();
	}
}


void Notify(const string &in msg, uint timeout = 5000) {
	UI::ShowNotification(Meta::ExecutingPlugin().Name, msg, timeout);
	trace("Notified: " + msg);
}

void NotifySuccess(const string &in msg, uint timeout = 10000) {
	print(msg);
	UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Success", msg, vec4(.1, .5, .1, .3), timeout);
}

void NotifyError(const string &in msg) {
	warn(msg);
	UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Error", msg, vec4(.7, .3, .1, .3), 15000);
}

void NotifyWarning(const string &in msg) {
	warn(msg);
	UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Warning", msg, vec4(.7, .5, .2, .3), 15000);
}



namespace UX {
	bool SmallButton(const string &in label, vec2 size = vec2(0, 0)) {
		UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(2, 1));
		bool pressed = UI::Button(label, size);
		UI::PopStyleVar();
		return pressed;
	}

	bool SmallButtonCB(const string &in label, CoroutineFunc@ cb, vec2 size = vec2()) {
		PushThinControls();
		bool pressed = SmallButton(label, size);
		if (pressed) {
			startnew(cb);
		}
		PopThinControls();
		return pressed;
	}

	void PushThinControls() {
		UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(2, 1));
		// UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(2, 1));
	}

	void PopThinControls() {
		UI::PopStyleVar(1);
	}

	void AlignTextToSmallFramePadding() {
		PushThinControls();
		UI::AlignTextToFramePadding();
		PopThinControls();
	}

	// add id to play cursor if need be
	void PlayCursorSlider(CAudioSource@ source, const string &in label = "Play Cursor") {
		float origCursorUi = source.PlayCursorUi;
		float newCursorUi = UI::SliderFloat(label, origCursorUi, 0., 1., Time::Format(int64(source.PlayCursor * 1000.)));
		if (newCursorUi != origCursorUi) {
			source.PlayCursorUi = newCursorUi;
		}
	}
}
