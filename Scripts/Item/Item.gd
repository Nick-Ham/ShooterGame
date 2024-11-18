extends Resource
class_name Item

@export_category("ResourceData")
@export var name : String = "Item"

func getModel() -> PackedScene:
	return null

func validate() -> bool:
	if getModel() == null:
		return false
	return true
