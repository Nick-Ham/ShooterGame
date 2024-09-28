extends Node
class_name CharacterState

@export_category("Config")
@export var acceleration : float = 2200.0
@export var maxSpeed : float = 2.0
@export var maxSpeedEnforcement : float = 10.0
@export var friction : float = 300.0
@export var staticFrictionScalar : float = 2.0
@export var jumpVelocity : float = 4.5

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

signal request_change_state(inStateKey : String)

func getStateKey() -> String:
	return ""

func handleOnJumpChanged(_inIsJumping : bool) -> void:
	return

func stateEntering() -> void:
	pass

func stateExiting() -> void:
	pass

func _ready() -> void:
	assert(getStateManager(), "CharacterState must be a child of a StateManager")

func update_physics(delta : float) -> void:
	applyGravity(delta)

	var character : CharacterBody3D = getStateManager().getCharacter()

	var direction : Vector3 = convertInputToDirection(getStateManager().getLastInputDirection(), character.transform.basis)

	var addedVelocity : Vector3 = calculateAddedPlanarVelocity(direction, delta)
	character.velocity += addedVelocity
	character.velocity = clampVelocityPlanar(character.velocity, delta)

	if character.is_on_floor() or character.is_on_wall():
		if is_zero_approx(direction.length_squared()):
			character.velocity = applyFriction(character.velocity, delta, staticFrictionScalar)
		else:
			character.velocity = applyFriction(character.velocity, delta, 1.0)

	character.move_and_slide()

func getStateManager() -> CharacterStateManager:
	return get_parent() as CharacterStateManager

func applyGravity(delta : float) -> void:
	if not getStateManager().getCharacter().is_on_floor():
		getStateManager().getCharacter().velocity.y -= gravity * delta

func calculateAddedPlanarVelocity(inDirection : Vector3, delta : float) -> Vector3:
	var addedVelocity : Vector3 = Vector3()
	if inDirection:
		addedVelocity.x += inDirection.x * acceleration * delta * delta
		addedVelocity.z += inDirection.z * acceleration * delta * delta

	return addedVelocity

func convertInputToDirection(inInputDirection : Vector2, inBasis : Basis) -> Vector3:
	return (inBasis * Vector3(inInputDirection.x, 0, inInputDirection.y)).normalized()

func clampVelocityPlanar(inVelocity : Vector3, delta : float) -> Vector3:
	var velocity2D : Vector2 = Vector2(inVelocity.x, inVelocity.z)
	velocity2D = lerp(velocity2D, velocity2D.limit_length(maxSpeed), maxSpeedEnforcement * delta)
	var result : Vector3 = Vector3(velocity2D.x, inVelocity.y, velocity2D.y)

	return result

func applyFriction(inVelocity : Vector3, delta : float, scalar : float) -> Vector3:
	var frictionDirection : Vector3 = -inVelocity.normalized()
	var length : float = inVelocity.length()
	var speedMultiplier : float = (length / maxSpeed) + 1
	var outVelocity : Vector3 = frictionDirection * friction * scalar * speedMultiplier * delta * delta

	return outVelocity + inVelocity

func getLeanDirection() -> Vector2:
	return Vector2(getStateManager().getLastInputDirection().x, 0)
