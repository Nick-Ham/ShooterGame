extends Node
class_name WeaponLibrary

static var pistolWeaponData : WeaponData = preload("res://Data/WeaponData/PistolWeaponData.tres")
static var junkBarrelWeaponData : WeaponData = preload("res://Data/WeaponData/JunkBarrelWeaponData.tres")
static var hammerGunWeaponData : WeaponData = preload("res://Data/WeaponData/HammerGunWeaponData.tres")

static func getWeapons() -> Array[WeaponData]:
	var weapons : Array[WeaponData] = [
		pistolWeaponData,
		junkBarrelWeaponData,
		hammerGunWeaponData
	]

	return weapons
