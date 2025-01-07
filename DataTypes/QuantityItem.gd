extends Item
class_name QuantityItem

@export_category("PickupType")
@export var tempType : String = "type"
@export var quantity : int = 0

@export_category("Config")
@export var itemModelScene : PackedScene

func getModel() -> PackedScene:
	return itemModelScene

func useHover() -> bool:
	return false

func useSpin() -> bool:
	return false
