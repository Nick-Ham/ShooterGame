extends Node3D
class_name Level

@export_category("PrototypingRef")
@export var playerCharacter : Character

var environmentalEffectManager : EnvironmentEffectManager

func _ready() -> void:
	environmentalEffectManager = EnvironmentEffectManager.new()
	add_child(environmentalEffectManager)

func getEnvironmentalEffectManager() -> EnvironmentEffectManager:
	return environmentalEffectManager

func getPlayerCharacter() -> Character:
	return playerCharacter
