extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		get_tree().quit()

func spawnDebugSphere(inPosition : Vector3) -> void:
	var debugSphere : DebugSphere = DebugSphere.new()
	get_tree().current_scene.add_child(debugSphere)
	debugSphere.global_position = inPosition

func spawnDebugTrail(inPositions : Array[Vector3]) -> void:
	var debugTrail : DebugTrail = DebugTrail.new()
	get_tree().current_scene.add_child(debugTrail)
	debugTrail.addPoints(inPositions)
