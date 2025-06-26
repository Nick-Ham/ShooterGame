extends Node
class_name PrototypeItemPicker

@export_category("Config")
@export var sets : Dictionary[Item, Item]

@export_category("Ref")
@export var itemSpawner1 : ItemPickup
@export var itemSpawner2 : ItemPickup

func _ready() -> void:
	var nextItem : Item = sets.keys().pick_random()
	var nextItem2 : Item = sets[nextItem]

	itemSpawner1.setItem(nextItem)
	itemSpawner2.setItem(nextItem2)
