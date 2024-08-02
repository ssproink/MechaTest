extends Node

var locale : String = "ru_RU":
	set(loc):
		locale = loc
		TranslationServer.set_locale(locale)

var volume : int = 100:
	set(value):
		volume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 
										linear_to_db(volume/100.0))
