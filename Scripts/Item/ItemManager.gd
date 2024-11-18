extends Node
class_name ItemManager

var items : Array[Item]

func addItem(inItem : Item) -> void:
	items.append(inItem)

func getItems() -> Array[Item]:
	return items
