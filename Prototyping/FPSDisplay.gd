extends Label
class_name FPSDisplay

func _process(_delta: float) -> void:
	var frameTime : float = Engine.get_frames_per_second()
	var frameTimeAsString : String = str(frameTime)
	text = frameTimeAsString
