extends Node3D
class_name Level

@export_category("PrototypingRef")
@export var playerCharacter : Character

var environmentalEffectManager : EnvironmentEffectManager
var environmentEventBus : EnvironmentEventBus

func _enter_tree() -> void:
	environmentalEffectManager = EnvironmentEffectManager.new()
	add_child(environmentalEffectManager)

	environmentEventBus = EnvironmentEventBus.new()
	add_child(environmentEventBus)

func getEnvironmentEventBus() -> EnvironmentEventBus:
	return environmentEventBus

func getEnvironmentalEffectManager() -> EnvironmentEffectManager:
	return environmentalEffectManager

func getPlayerCharacter() -> Character:
	return playerCharacter
