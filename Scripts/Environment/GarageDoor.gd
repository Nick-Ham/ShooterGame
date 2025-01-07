extends StaticBody3D
class_name GarageDoor

@export_category("Config")
@export var openByDefault : bool = false

@export_group("SwitchControl")
@export var controllingSwitch : SwitchInteractable

@export_category("Ref")
@export var doorPivot : Node3D
@export var interactable : Interactable
@export var animationPlayer : AnimationPlayer
@export var failOpenStreamPlayer : AudioStreamPlayer3D
@export var metalThudStreamPlayer : AudioStreamPlayer3D
@export var garageDoorMechStreamPlayer : AudioStreamPlayer3D
@export var inputRejectStreamPlayer : AudioStreamPlayer3D

const failOpenAnimationKey : String = "failOpen"
const toggleDoorAnimationKey : String = "toggleDoor"

const doorOpenPosition : Vector3 = Vector3(0, 2.5, 0)
const doorClosedPosition : Vector3 = Vector3()

var isOpen : bool = false

signal door_state_changed(isOpen : bool)

func _ready() -> void:
	assert(interactable)
	assert(animationPlayer)
	assert(metalThudStreamPlayer)
	assert(garageDoorMechStreamPlayer)

	Util.safeConnect(interactable.interact_changed, on_interact_changed)

	setIsOpen(openByDefault, false)

	if is_instance_valid(controllingSwitch):
		Util.safeConnect(controllingSwitch.switch_state_changed, on_switch_state_changed)
		setIsOpen(controllingSwitch.getIsSwitchOn(), false)

	Util.safeConnect(animationPlayer.animation_finished, on_animation_finished)

func on_animation_finished(inAnimation : String) -> void:
	if inAnimation != toggleDoorAnimationKey:
		return

	metalThudStreamPlayer.play()
	failOpenStreamPlayer.play()


func on_interact_changed(inIsInteracting : bool) -> void:
	if !inIsInteracting:
		return

	if !is_instance_valid(controllingSwitch):
		#setIsOpen(!isOpen, true) # disable manual opening until needed
		return

	if animationPlayer.is_playing() || isOpen:
		return

	inputRejectStreamPlayer.play()
	animationPlayer.play(failOpenAnimationKey)

func on_switch_state_changed(inIsSwitchOn : bool, inShouldAnimate : bool) -> void:
	setIsOpen(inIsSwitchOn, inShouldAnimate)

func setIsOpen(inIsOpen : bool, inShouldAnimate : bool) -> void:
	isOpen = inIsOpen

	if inShouldAnimate:
		if isOpen:
			animationPlayer.play(toggleDoorAnimationKey)
		else:
			animationPlayer.play_backwards(toggleDoorAnimationKey)
		garageDoorMechStreamPlayer.play()
	else:
		doorPivot.position = doorOpenPosition if isOpen else doorClosedPosition

	door_state_changed.emit(isOpen)
