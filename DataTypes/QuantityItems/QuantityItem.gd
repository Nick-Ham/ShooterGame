extends Item
class_name QuantityItem

@export_category("PickupType")
@export var quantity : int = 0

@export_category("Config")
@export var itemModelScene : PackedScene
@export var itemCategory : ItemCategory = ItemCategory.Default

func getItemCategory() -> ItemCategory:
	return itemCategory

func getModel() -> PackedScene:
	return itemModelScene
