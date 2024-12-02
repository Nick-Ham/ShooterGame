extends Node

func _ready() -> void:
	print_debug("Remove PrototypingUtil singleton before release.")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		get_tree().quit()
