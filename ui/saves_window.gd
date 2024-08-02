extends VBoxContainer

enum Mode { LOAD, SAVE }

@export var mode : Mode = Mode.LOAD :
	set(new_mode):
		mode = new_mode
		if mode == Mode.LOAD:
			$Caption.text = "LOAD_GAME"
			$Buttons/LoadSaveGameButton.text = "BUTTON_LOAD_GAME"
		elif mode == Mode.SAVE:
			$Caption.text = "SAVE_GAME"
			$Buttons/LoadSaveGameButton.text = "BUTTON_SAVE_GAME"

func set_load_mode():
	mode = Mode.LOAD

func set_save_mode():
	mode = Mode.SAVE

func _on_cancel_button_pressed():
	visible = false
