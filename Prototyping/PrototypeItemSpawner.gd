extends Node
class_name PrototypeItemSpawner

@export_category("Config")
@export var spawnOptions : Array[Item]

@onready var itemPickupPacked : PackedScene = preload("res://Scenes/Environment/ItemPickup.tscn")
@onready var owningCharacter : Character = Character.getOwningCharacter(self)

func _ready() -> void:
	assert(spawnOptions.size() > 0)

	Util.safeConnect(owningCharacter.character_destroyed, on_character_destroyed)

func on_character_destroyed(_inCharacter : Character) -> void:
	spawnNewItem()
	queue_free()

func spawnNewItem() -> void:
	var level : Level = Game.getGame(get_tree()).getLevel()

	for i : int in range(getNumOfItems()):
		var nextOption : Item = spawnOptions.pick_random()

		var newItemPickupInstance : ItemPickup = itemPickupPacked.instantiate()
		newItemPickupInstance.setItem(nextOption)

		level.add_child(newItemPickupInstance)
		var newOffset : Vector2 = RandUtil.getRandomOffset(1.0)
		newItemPickupInstance.global_position = owningCharacter.global_position + Vector3(newOffset.x, 0.0, newOffset.y)

func getNumOfItems() -> int:
	var newRand : float = randf()
	if newRand < 0.6:
		return 2
	elif newRand < .85:
		return 3

	return 1
