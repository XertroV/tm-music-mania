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

	// float _cursorSliderHeld = -1;
	dictionary _cursorSliderHeldD;
	double _GetCursorSliderHeld(const string &in key) {
		double val;
		if (_cursorSliderHeldD.Get(key, val)) {
			return val;
		}
		return -1;
	}

	// add id to label if need be; play cursor if paused is <seconds, ui>
	void PlayCursorSlider(CAudioSource@ source, const string &in label = "Play Cursor", vec2 playCursorIfPaused = vec2(0.0)) {
		if (source is null) {
			UI::SliderFloat(label, 0.0, 0., 1., "[ No source ]");
			return;
		}
		bool isPaused = !source.IsPlaying && playCursorIfPaused.x > 0;

		float cur = (isPaused ? playCursorIfPaused.x : source.PlayCursor);
		auto fmtLabel = Time::Format(int64(cur * 1000.));

		float origCursorUi = isPaused ? playCursorIfPaused.y : source.PlayCursorUi;

		float newCursorUi = UI::SliderFloat(label, origCursorUi, 0., 1., fmtLabel);
		if (newCursorUi != origCursorUi) {
			if (_GetCursorSliderHeld(label) != newCursorUi) {
				source.PlayCursorUi = newCursorUi;
			}
		}
		_cursorSliderHeldD[label] = UI::IsItemActive() ? newCursorUi : -1;
	}
}
