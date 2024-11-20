extends Node3D
class_name Weapon

@onready var weaponStateManager : WeaponStateManager = Util.getChildOfType(self, WeaponStateManager)

var currentWeaponData : WeaponData = null

func readyWeapon() -> void:
	weaponStateManager.readyWeapon()

func injectWeaponData(inWeaponData : WeaponData) -> void:
	currentWeaponData = inWeaponData

func getWeaponData() -> WeaponData:
	return currentWeaponData

func getCurrentBloomValue() -> float:
	return weaponStateManager.getCurrentBloomValue()
