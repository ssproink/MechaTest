class_name Settings

static func code_to_event(code):
	var inputEvent : InputEvent = null
	if code is int:
		var inputEventKey = InputEventKey.new()
		inputEventKey.physical_keycode = code
		inputEvent = inputEventKey
	elif code is String:
		match code[0]:
			'M': # mouse button
				var inputEventMouseButton = InputEventMouseButton.new()
				inputEventMouseButton.button_index = int(code.substr(1))
				inputEvent = inputEventMouseButton
			'J': # joystick button
				var inputEventJoypadButton = InputEventJoypadButton.new()
				inputEventJoypadButton.button_index = int(code.substr(1))
				inputEvent = inputEventJoypadButton
	return inputEvent

static func event_to_code(event : InputEvent):
	if event is InputEventKey:
		return event.physical_keycode
	if event is InputEventMouseButton:
		return "M" + str(event.button_index)
	if event is InputEventJoypadButton:
		return "J" + str(event.button_index)
	return null

static func root():
	if OS.has_feature("editor"):
		return "res://"
	else:
		return OS.get_executable_path().get_base_dir()

static func load(path : String = root().path_join("settings.cfg")):
	var config = ConfigFile.new()
	var err = config.load(path)
	if err != OK:
		default(path)
		return err
	CommonSettings.locale = config.get_value("common", "locale")
	CommonSettings.volume = config.get_value("common", "volume")
	for keybinding in config.get_section_keys("keybindings"):
		var code = config.get_value("keybindings", keybinding, 0)
		InputMap.action_erase_events(keybinding)
		var inputEvent : InputEvent = code_to_event(code)
		if inputEvent != null:
			InputMap.action_add_event(keybinding, inputEvent)
	return OK

static func save(path : String = root().path_join("settings.cfg")):
	var config = ConfigFile.new()
	config.set_value("common", "locale", CommonSettings.locale)
	config.set_value("common", "volume", CommonSettings.volume)
	for action in InputMap.get_actions():
		if action.begins_with("ui_"): # skip default actions
			continue
		var events = InputMap.action_get_events(action)
		if events.is_empty():
			continue
		var code = event_to_code(events[0])
		if code != null:
			config.set_value("keybindings", action, code)
	config.save(path)

static func default(path : String = root().path_join("settings.cfg")):
	var dirAccess = DirAccess.open(root())
	dirAccess.copy(root().path_join("default/settings.cfg"), path)
