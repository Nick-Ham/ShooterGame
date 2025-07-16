extends Node
class_name PlayerCrouchController

@export_category("Ref")
@export var collisionShapeStanding : CollisionShape3D
@export var collisionShapeCrouching : CollisionShape3D
@export var standingNeckPosition : Marker3D
@export var crouchingNeckPosition : Marker3D
@export var neck : Node3D

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var characterStateManager : CharacterStateManager = Util.getChildOfType(owningCharacter, CharacterStateManager)

func _ready() -> void:
	assert(collisionShapeStanding)
	assert(collisionShapeCrouching)
	assert(standingNeckPosition)
	assert(crouchingNeckPosition)
	assert(characterStateManager)

	Util.safeConnect(characterStateManager.state_changed, on_state_changed)

func on_state_changed(_lastState : CharacterState, newState : CharacterState) -> void:
	var isCrouchingState : bool = newState.getIsCrouchingState()
	
	var newNeckPosition : Vector3 = crouchingNeckPosition.position if isCrouchingState else standingNeckPosition.position
	neck.position = newNeckPosition
	
	collisionShapeCrouching.disabled = !isCrouchingState
	collisionShapeStanding.disabled = isCrouchingState
	
	return
