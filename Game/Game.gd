extends Node
class_name Game

@export_category("GameConfig")
@export var initialLevelScene : PackedScene

var currentLevel : Level = null

func _ready() -> void:
	changeLevel(initialLevelScene)

func changeLevel(inLevelScene : PackedScene) -> void:
	if is_instance_valid(currentLevel):
		currentLevel.queue_free()
		currentLevel = null

	currentLevel = inLevelScene.instantiate()
	add_child(currentLevel)

func getLevel() -> Level:
	return currentLevel
