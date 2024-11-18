extends Item
class_name KeyItem

@export_category("Config")
@export var doorKey : String = ""

var keyModel : PackedScene = preload("res://Assets/Models/Key/KeyModel.tscn")

func getModel() -> PackedScene:
	return keyModel
