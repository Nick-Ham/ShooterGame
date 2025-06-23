extends StaticBody3D
class_name SwitchInteractable

@export_category("Config")
@export var onByDefault : bool = false
@export var canTurnOn : bool = true
@export var canTurnOff : bool = true

@export_category("SwitchPosition")
@export_group("SwitchOn")
@export var switchOnPosition : Vector3 = Vector3()
@export var switchOnRotation : Vector3 = Vector3()
@export_group("SwitchOff")
@export var switchOffPosition : Vector3 = Vector3()
@export var switchOffRotation : Vector3 = Vector3()

@export_category("Ref")
@export var switchPivot : Node3D
@export var animationPlayer : AnimationPlayer
@export var interactable : Interactable

@export var inputAcceptStream : AudioStreamPlayer3D
@export var inputRejectStream : AudioStreamPlayer3D

const switchOnAnimationKey : String = "switchOn"
const switchOffAnimationKey : String = "switchOff"

var isSwitchOn : bool = false

signal switch_state_changed(isSwitchOn : bool, shouldAnimate : bool)

func _ready() -> void:
	assert(switchPivot)
	assert(animationPlayer)
	assert(interactable)

	setSwitchState(onByDefault, false)

	Util.safeConnect(interactable.interact_changed, on_interact_changed)

func getIsSwitchOn() -> bool:
	return isSwitchOn

func on_interact_changed(inIsInteracting : bool) -> void:
	if !inIsInteracting:
		return

	if isSwitchOn and !canTurnOff:
		inputRejectStream.play()
		return

	if !isSwitchOn and !canTurnOn:
		inputRejectStream.play()
		return

	inputAcceptStream.play()
	setSwitchState(!isSwitchOn)

func setSwitchState(inIsOn : bool, inShouldAnimate : bool = true) -> void:
	isSwitchOn = inIsOn

	if inShouldAnimate:
		animationPlayer.play(switchOnAnimationKey if isSwitchOn else switchOffAnimationKey)
	else:
		switchPivot.position = switchOnPosition if isSwitchOn else switchOffPosition
		switchPivot.rotation = switchOnRotation if isSwitchOn else switchOffRotation

	switch_state_changed.emit(isSwitchOn, inShouldAnimate)
