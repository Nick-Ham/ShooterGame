extends Node
class_name ItemManager

var items : Array[Item]

signal item_added(inItem : Item)

func consumeItem(inItem : Item) -> void:
	if items.has(inItem):
		items.erase(inItem)

func addItem(inItem : Item) -> void:
	items.append(inItem)
	item_added.emit(inItem)

func getItems() -> Array[Item]:
	return items
