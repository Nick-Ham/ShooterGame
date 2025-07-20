extends Node3D
class_name Level

@onready var playerScene : PackedScene = preload("res://Scenes/Player/Player.tscn")
@onready var spectatorScene : PackedScene = preload("res://Scenes/Player/Spectator.tscn")

@export_category("Ref")
@export var navRegion : NavigationRegion3D

@export_category("Config")
@export var useSpectator : bool = false
@export var enableSpawnTriggers : bool = true

## LevelSystems
var environmentalEffectManager : EnvironmentEffectManager = null
var environmentEventBus : EnvironmentEventBus = null
var levelEventHandler : LevelEventHandler = null
var levelBuilder : LevelBuilder = null

var playerCharacter : Character = null

func getSpawnTriggersEnabled() -> bool:
	return enableSpawnTriggers

func _enter_tree() -> void:
	environmentalEffectManager = EnvironmentEffectManager.new()
	add_child(environmentalEffectManager)

	environmentEventBus = EnvironmentEventBus.new()
	add_child(environmentEventBus)

	levelEventHandler = LevelEventHandler.new()
	add_child(levelEventHandler)

	levelBuilder = LevelBuilder.new()
	add_child(levelBuilder)

func _ready() -> void:
	assert(navRegion)

	bindLevelEventHandler()

	levelBuilder.buildMap()
	spawnPlayer()

	# skip rebake for now, not even sure if its a problem
	#navRegion.bake_navigation_mesh(true)

func bindLevelEventHandler() -> void:
	if playerCharacter:
		Util.safeConnect(playerCharacter.character_destroyed, levelEventHandler.on_player_destroyed)

func getEnvironmentEventBus() -> EnvironmentEventBus:
	return environmentEventBus

func getEnvironmentalEffectManager() -> EnvironmentEffectManager:
	return environmentalEffectManager

func getLevelBuilder() -> LevelBuilder:
	return levelBuilder

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
