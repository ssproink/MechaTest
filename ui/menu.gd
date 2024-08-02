extends Node

func _ready():
	var err = Settings.load()
	if err != OK:
		OS.alert(tr("SETTINGS_ERROR"), tr("ERROR"))
		get_tree().quit()

func _on_load_game_pressed():
	$Overlay/LoadSaveWindow.set_load_mode()
	$Overlay/LoadSaveWindow.visible = true

func _on_settings_pressed():
	$Overlay/Settings.open()

func _on_exit_pressed():
	get_tree().quit()
