extends Node3D
class_name Level

@onready var playerScene : PackedScene = preload("res://Scenes/Player/Player.tscn")
@onready var spectatorScene : PackedScene = preload("res://Scenes/Player/Spectator.tscn")

@export_category("Config")
@export var useSpectator : bool = false

## LevelSystems
var environmentalEffectManager : EnvironmentEffectManager = null
var environmentEventBus : EnvironmentEventBus = null
var levelEventHandler : LevelEventHandler = null

var playerCharacter : Character = null

func _enter_tree() -> void:
	environmentalEffectManager = EnvironmentEffectManager.new()
	add_child(environmentalEffectManager)

	environmentEventBus = EnvironmentEventBus.new()
	add_child(environmentEventBus)

	levelEventHandler = LevelEventHandler.new()
	add_child(levelEventHandler)

func _ready() -> void:
	spawnPlayer()

	bindLevelEventHandler()

func bindLevelEventHandler() -> void:
	if playerCharacter:
		Util.safeConnect(playerCharacter.character_destroyed, levelEventHandler.on_player_destroyed)

func getEnvironmentEventBus() -> EnvironmentEventBus:
	return environmentEventBus

func getEnvironmentalEffectManager() -> EnvironmentEffectManager:
	return environmentalEffectManager

func spawnPlayer() -> void:
	var playerSpawn : PlayerSpawn = Util.getChildOfType(self, PlayerSpawn)
	if !playerSpawn:
		push_error("No player spawn!")
		return

	if useSpectator:
		var spectator : Spectator = spectatorScene.instantiate()
		spectator.transform = playerSpawn.global_transform
		add_child(spectator)
		return

	playerCharacter = playerScene.instantiate()
	playerCharacter.transform = playerSpawn.global_transform
	add_child(playerCharacter)

func getPlayerCharacter() -> Character:
	return playerCharacter
