extends Node
class_name Game

@export_category("GameConfig")
@export var initialLevelScene : PackedScene

var currentLevel : Level = null
var currentLevelScene : PackedScene = null

func _ready() -> void:
	changeLevel(initialLevelScene)

func changeLevel(inLevelScene : PackedScene) -> void:
	if is_instance_valid(currentLevel):
		currentLevel.queue_free()
		currentLevel = null
		currentLevelScene = null

	currentLevelScene = inLevelScene
	currentLevel = inLevelScene.instantiate()
	add_child(currentLevel)

func getLevel() -> Level:
	return currentLevel

func resetCurrentLevel() -> void:
	changeLevel(currentLevelScene)

static func getGame(inTree : SceneTree) -> Game:
	return inTree.current_scene as Game
