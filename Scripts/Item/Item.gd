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

func useHover() -> bool:
	return true

func useSpin() -> bool:
	return true
