extends Node
class_name WeaponAnimationController

@export_category("Ref")
@export var animationPlayer : AnimationPlayer
@export var audioAnimationPlayer : AnimationPlayer

const weaponReloadAnimationKey : String = "reload"
const weaponShootAnimationKey : String = "shoot"

signal shoot_ended
signal reload_ended

func _ready() -> void:
	Util.safeConnect(animationPlayer.animation_finished, on_animation_finished)

func on_animation_finished(inAnimationName : String) -> void:
	if inAnimationName == weaponShootAnimationKey:
		shoot_ended.emit()
		return

	if inAnimationName == weaponReloadAnimationKey:
		reload_ended.emit()
		return

func playShoot() -> void:
	if !animationPlayer:
		return

	if animationPlayer.has_animation(weaponShootAnimationKey):
		animationPlayer.play(weaponShootAnimationKey)
		animationPlayer.seek(0, true)

	if audioAnimationPlayer.has_animation(weaponShootAnimationKey):
		audioAnimationPlayer.play(weaponShootAnimationKey)
		audioAnimationPlayer.seek(0, true)

func playReload() -> void:
	if !animationPlayer:
		return

	if animationPlayer.is_playing() and animationPlayer.current_animation == weaponReloadAnimationKey:
		return

	if animationPlayer.has_animation(weaponReloadAnimationKey):
		animationPlayer.play(weaponReloadAnimationKey)
		animationPlayer.seek(0, true)

	if audioAnimationPlayer.has_animation(weaponReloadAnimationKey):
		audioAnimationPlayer.play(weaponReloadAnimationKey)
		audioAnimationPlayer.seek(0, true)
