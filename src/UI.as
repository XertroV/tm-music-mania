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
