extends Node
class_name Targeter

@export_category("Ref")
@export var losTracker : LOSTracker

@export_category("Config")
@export var targetLostTime : float = 2.0
@export var defaultRememberTargetTime : float = 2.0

var target : Node3D
var positionOfInterest : Vector3

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var lastKnownPosition : Vector3 = get_parent().global_position

signal target_acquired(inTarget : Node3D)
signal target_lost(inTarget : Node3D, lossReason : LOSTracker.LossReason)

class TargetInterest extends RefCounted:
	var isInterestPosition : bool = false
	var interest : Node3D = null
	var interestPosition : Vector3 = Vector3()
	var interestDirection : Vector3 = Vector3()

func _ready() -> void:
	assert(losTracker)

	var level : Level = Game.getGame(get_tree()).getLevel()
	var environmentEventBus : EnvironmentEventBus = level.getEnvironmentEventBus()

	Util.safeConnect(environmentEventBus.sound_triggered, on_environment_sound_triggered)
	Util.safeConnect(losTracker.character_lost, on_character_lost)

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

func on_environment_sound_triggered(inSource : Node3D) -> void:
	## This should really be moved to the investigationManager
	var investigationManager : AIInvestigationManager = Util.getChildOfType(owningCharacter, AIInvestigationManager)
	if !investigationManager:
		push_error("Targeter will not function correctly without an AIInvestigationManager")
		return

	if target:
		return

	if inSource == owningCharacter:
		return

	var sourceAsCharacter : Character = inSource as Character
	if !sourceAsCharacter:
		return

	if sourceAsCharacter.team == owningCharacter.team:
		return

	investigationManager.createInvestigation(sourceAsCharacter)

	#var sourcePosition : Vector3 = inSource.global_position
	#var sourceAsCharacter : Character = inSource as Character
	#if sourceAsCharacter:
		#sourcePosition = sourceAsCharacter.getHeadGlobalPosition()
#
	#positionOfInterest = sourcePosition

func on_character_lost(inCharacter : Character, inLossReason : LOSTracker.LossReason) -> void:
	if !inCharacter == target:
		return

	if !target:
		return

	var currentInterest : TargetInterest = getInterest()
	positionOfInterest = currentInterest.interestPosition

	var previousTarget : Node3D = target
	target = null
	target_lost.emit(previousTarget, inLossReason)

func acquireTarget(inTarget : Node3D = null) -> Node3D:
	if inTarget:
		target = inTarget

	if target:
		return target

	var visibleCharacters : Array[Character] = losTracker.getVisibleCharacters()
	for character : Character in visibleCharacters:
		if character.team == owningCharacter.team:
			continue

		target = character
		target_acquired.emit(target)
		return target

	return null

func on_target_destroyed(inCharacter : Character) -> void:
	target = null
	target_lost.emit(inCharacter, LOSTracker.LossReason.DESTRUCTION)

func hasTarget() -> bool:
	return is_instance_valid(target)

func getTarget() -> Node3D:
	return target

func forceUpdatePositionOfInterest(inPosition : Vector3) -> void:
	positionOfInterest = inPosition

func forceClearPositionOfInterest() -> void:
	positionOfInterest = Vector3()
