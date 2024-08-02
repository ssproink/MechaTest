class_name KeyButton
extends Button

@export var event : InputEvent = null :
	set(ev):
		event = ev
		if ev != null:
			if ev is InputEventKey:
				text = ev.as_text_physical_keycode()
			else:
				text = ev.as_text()
		else:
			text = "None"

@export var listen = false :
	set(value):
		listen = value
		if value:
			add_theme_color_override("font_color", Color.RED)
			add_theme_color_override("font_focus_color", Color.RED)
			add_theme_color_override("font_hover_color", Color.RED)
			add_theme_color_override("font_hover_pressed_color", Color.RED)
		else:
			remove_theme_color_override("font_color")
			remove_theme_color_override("font_focus_color")
			remove_theme_color_override("font_hover_color")
			remove_theme_color_override("font_hover_pressed_color")

func _on_pressed():
	if not listen:
		listen = true

func _input(event):
	if listen:
		if event is InputEventKey:
			if event.keycode != KEY_ESCAPE:
				self.event = event
			listen = false
		elif event is InputEventMouseButton \
		or event is InputEventJoypadButton:
			self.event = event
			listen = false
