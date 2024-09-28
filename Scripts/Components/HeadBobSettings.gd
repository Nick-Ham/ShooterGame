extends Node
class_name HeadBobSettings

@export_category("Config")
@export var isEnabled : bool = true
@export var periodScalar : float = 1.0
@export var amplitudeScalar : float = 1.0

func getIsEnabled() -> bool:
	return isEnabled

func getPeriodScalar() -> float:
	return periodScalar

func getAmplitudeScalar() -> float:
	return amplitudeScalar
