extends Node

func _ready():
	Settings.save("res://default/settings.cfg")
	var dirAccess = DirAccess.open("res://")
	dirAccess.copy("res://default/settings.cfg", "res://settings.cfg")
	get_tree().quit()
