extends Node3D
class_name Level

var environmentalEffectManager : EnvironmentEffectManager

func _ready() -> void:
	environmentalEffectManager = EnvironmentEffectManager.new()
	add_child(environmentalEffectManager)

func getEnvironmentalEffectManager() -> EnvironmentEffectManager:
	return environmentalEffectManager
