extends Node3D
class_name SpawnPad

func _ready() -> void:
	var level : Level = Game.getGame(get_tree()).getLevel()
	var levelSpawnManager : LevelSpawnManager = Util.getChildOfType(level, LevelSpawnManager)

	levelSpawnManager.registerSpawnPad(self)

func spawnObject(inPackedScene : PackedScene) -> void:
	var level : Level = Game.getGame(get_tree()).getLevel()

	var newInstance : Node3D = inPackedScene.instantiate()

	level.add_child(newInstance)

	newInstance.global_position = global_position
	newInstance.rotation = rotation
