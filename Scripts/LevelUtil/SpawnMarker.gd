extends Node3D
class_name SpawnMarker

@export_category("Config")
@export var characterToSpawn : PackedScene

func _ready() -> void:
	assert(characterToSpawn)

func spawn() -> void:
	var level : Level = Game.getGame(get_tree()).getLevel()

	var newCharacter : Character = characterToSpawn.instantiate()
	newCharacter.global_transform = global_transform

	level.add_child(newCharacter)
