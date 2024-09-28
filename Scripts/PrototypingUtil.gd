extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		get_tree().quit()
