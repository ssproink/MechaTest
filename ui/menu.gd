extends Node

func _init():
	randomize()

func _ready():
	var err = Settings.load()
	if err != OK:
		OS.alert(tr("SETTINGS_ERROR"), tr("ERROR"))
		get_tree().quit()

func _on_load_game_pressed():
	$CanvasLayer/Overlay/LoadSaveWindow.set_load_mode()
	$CanvasLayer/Overlay/LoadSaveWindow.visible = true

func _on_settings_pressed():
	$CanvasLayer/Overlay/Settings.open()

func _on_exit_pressed():
	get_tree().quit()
