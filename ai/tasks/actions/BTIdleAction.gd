@tool
extends BTAction
class_name BTIdleAction

func _generate_name() -> String:
	return "Idle"

func _tick(_delta: float) -> Status:
	return Status.RUNNING
