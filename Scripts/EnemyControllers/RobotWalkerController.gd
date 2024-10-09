extends Controller
class_name RobotWalkerController

func _process(_delta: float) -> void:
	#inputDirection.y = -1
	input_direction_changed.emit(inputDirection)
