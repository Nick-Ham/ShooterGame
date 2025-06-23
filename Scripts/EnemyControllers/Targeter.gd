extends Node
class_name Targeter

var target : Node3D
var positionOfInterest : Vector3

var targetVar : String = &"target"

@export_category("Ref")
@export var btPlayer : BTPlayer

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var losTracker : LOSTracker = Util.getChildOfType(owningCharacter, LOSTracker)

signal target_acquired(inTarget : Node3D)
signal target_lost(inTarget : Node3D, lossReason : LOSTracker.LossReason)

class TargetInterest extends RefCounted:
	var isInterestPosition : bool = false
	var interest : Node3D = null
	var interestPosition : Vector3 = Vector3()
	var interestDirection : Vector3 = Vector3()

func _ready() -> void:
	assert(btPlayer)
	assert(losTracker, "Requires an LOSTracker to function on the parent character.")

	var level : Level = Game.getGame(get_tree()).getLevel()
	var environmentEventBus : EnvironmentEventBus = level.getEnvironmentEventBus()

	Util.safeConnect(losTracker.character_detected, acquireTarget)

func getInterest() -> TargetInterest:
	var interest : TargetInterest = TargetInterest.new()

	if target:
		interest.interest = target
		var targetAsCharacter : Character = target as Character
		if targetAsCharacter:
			interest.interestPosition = targetAsCharacter.getHeadGlobalPosition()
			interest.interestDirection = targetAsCharacter.velocity.normalized()
			return interest

		interest.interestPosition = target.global_position
		return interest

	if positionOfInterest.is_zero_approx():
		return null

	interest.isInterestPosition = true
	interest.interestPosition = positionOfInterest
	return interest

func updateBlackboard() -> void:
	if !Util.isValid(target):
		btPlayer.blackboard.set_var(targetVar, null)
		return

	btPlayer.blackboard.set_var(targetVar, target)

func acquireTarget(_inTarget : Node3D = null) -> Node3D:
	if target:
		return target

	var visibleCharacters : Array[Character] = losTracker.getVisibleCharacters()
	for character : Character in visibleCharacters:
		if character.team == owningCharacter.team:
			continue

		target = character
		target_acquired.emit(target)

		updateBlackboard()
		return target

	return null

func on_target_destroyed(inCharacter : Character) -> void:
	target = null
	target_lost.emit(inCharacter, LOSTracker.LossReason.DESTRUCTION)
	acquireTarget()

func hasTarget() -> bool:
	return is_instance_valid(target)

func getTarget() -> Node3D:
	return target

func forceUpdatePositionOfInterest(inPosition : Vector3) -> void:
	positionOfInterest = inPosition

func forceClearPositionOfInterest() -> void:
	positionOfInterest = Vector3()
