extends VBoxContainer

const KeyButton_ = preload("res://ui/key_button.tscn")

var locale_map : Dictionary = { } # locale : locale_name
var action_map : Dictionary = { } # action : Key (button)
var immutable_actions : Array[String] = [ "cancel" ]

func _ready():
	var actions = InputMap.get_actions()
	actions = actions.filter(func(action): return not action.begins_with("ui_"))
	actions = actions.filter(func(action): return action not in immutable_actions)
	for action in actions:
		var label = Label.new()
		label.text = "SETTINGS_KEY_" + action.to_upper()
		var key = KeyButton_.instantiate()
		action_map[action] = key
		$SettingsList.add_child(label)
		$SettingsList.add_child(key)

func _on_cancel_button_pressed():
	visible = false
	TranslationServer.set_locale(CommonSettings.locale)
	for el in $SettingsList.get_children():
		if el is KeyButton:
			el.listen = false

func open():
	view_settings()
	visible = true

func view_settings():
	# common settings
	$SettingsList/Locale.clear()
	for locale in TranslationServer.get_loaded_locales():
		locale_map[locale] = TranslationServer.get_locale_name(locale)
		$SettingsList/Locale.add_item(locale_map[locale])
		if CommonSettings.locale.begins_with(locale):
			$SettingsList/Locale.select($SettingsList/Locale.item_count-1)
	$SettingsList/Volume.set_volume(CommonSettings.volume)
	# keybindings
	for action in action_map:
		var key = action_map[action]
		key.event = InputMap.action_get_events(action)[0]

func save():
	CommonSettings.locale = locale_map.find_key(
		$SettingsList/Locale.get_item_text(
			$SettingsList/Locale.get_selected_id()))
	CommonSettings.volume = $SettingsList/Volume.volume
	for action in action_map:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, action_map[action].event)
	Settings.save()

func _on_language_item_selected(index):
	TranslationServer.set_locale(
		locale_map.find_key($SettingsList/Locale.get_item_text(index)))

func _on_ok_button_pressed():
	save()
	visible = false

func _on_default_settings_button_pressed():
	Settings.default()
	Settings.load()
	view_settings()
