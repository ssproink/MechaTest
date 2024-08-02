extends HBoxContainer

var volume : int = 0 

func get_volume():
	return volume
	
func set_volume(value : int):
	volume = value
	$Slider.value = value
	$SpinBox.value = value

func _on_slider_value_changed(value):
	volume = value
	$SpinBox.value = value

func _on_spin_box_value_changed(value):
	volume = value
	$Slider.value = value
