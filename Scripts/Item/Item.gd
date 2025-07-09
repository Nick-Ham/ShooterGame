extends Resource
class_name Item

enum ItemCategory {
	Default,
	Weapon,
	Ammo,
	Healing,
}

static var CategoryColor : Dictionary[ItemCategory, Color] = {
	ItemCategory.Default : Color.WHITE,
	ItemCategory.Weapon : Color.DARK_ORANGE,
	ItemCategory.Ammo : Color.ANTIQUE_WHITE,
	ItemCategory.Healing : Color.MEDIUM_SEA_GREEN,
}

@export_category("ResourceData")
@export var name : String = "Item"

static func getCategoryColor(inCategory : ItemCategory) -> Color:
	if !CategoryColor.has(inCategory):
		push_warning("Category not contained in CategoryColor")
		return Color.HOT_PINK
	
	return CategoryColor[inCategory]

func getItemCategory() -> ItemCategory:
	return ItemCategory.Default

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
