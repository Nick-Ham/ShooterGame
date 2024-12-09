extends Node
class_name WeaponReloadComponent

@export_category("Ref")
@export var weaponAnimationPlayer : AnimationPlayer
@export var audioAnimationPlayer : AnimationPlayer

@onready var weaponStateManager : WeaponStateManager = Util.getChildOfType(get_parent(), WeaponStateManager)

const weaponReloadAnimationKey : String = "reload"

signal reload_complete

func _ready() -> void:
	assert(weaponAnimationPlayer)
	assert(audioAnimationPlayer)

	Util.safeConnect(weaponAnimationPlayer.animation_finished, on_reload_animation_finished)

func reload() -> void:
	weaponStateManager.setCurrentAmmo(0)

	weaponAnimationPlayer.play(weaponReloadAnimationKey)
	audioAnimationPlayer.play(weaponReloadAnimationKey)

func on_reload_animation_finished(_inAnimationName : String) -> void:
	weaponStateManager.setCurrentAmmo(weaponStateManager.getWeaponData().magazineSize)

	reload_complete.emit()
