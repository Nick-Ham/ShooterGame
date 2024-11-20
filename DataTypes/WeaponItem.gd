extends Item
class_name WeaponItem

@export_category("Config")
@export var weaponData : WeaponData

func getModel() -> PackedScene:
	return weaponData.weaponModelScene
