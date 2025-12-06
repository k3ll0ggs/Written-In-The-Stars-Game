extends VBoxContainer

func _on_button_pressed() -> void:
	$".."._changeHealth(-99)
