extends StaticBody3D
class_name SwitchInteractable

@export_category("Config")
@export var onByDefault : bool = false
@export var canTurnOn : bool = true
@export var canTurnOff : bool = true

@export_category("Ref")
@export var rockerPivot : Node3D
@export var animationPlayer : AnimationPlayer
@export var interactable : Interactable

@export var inputAcceptStream : AudioStreamPlayer3D
@export var inputRejectStream : AudioStreamPlayer3D

const switchOnPosition : Vector3 = Vector3(0, -0.044, -0.056)
const switchOffPosition : Vector3 = Vector3(0, 0.02, -0.056)

const switchOnAnimationKey : String = "switchOn"
const switchOffAnimationKey : String = "switchOff"

var isSwitchOn : bool = false

signal switch_state_changed(isSwitchOn : bool, shouldAnimate : bool)

func _ready() -> void:
	assert(rockerPivot)
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
		rockerPivot.position = switchOnPosition if isSwitchOn else switchOffPosition

	switch_state_changed.emit(isSwitchOn, inShouldAnimate)
