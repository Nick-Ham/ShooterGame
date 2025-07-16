extends Node
class_name CharacterState

@export_category("Config")
@export var acceleration : float = 55.0
@export var maxSpeed : float = 2.0
@export var maxSpeedEnforcement : float = 10.0
@export var friction : float = 15.0
@export var slowingFrictionScalar : float = 1.0
@export var jumpVelocity : float = 5.8

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

signal request_change_state(inStateKey : String)

func getStateKey() -> String:
	return ""

func handleOnJumpChanged(_inIsJumping : bool) -> void:
	return

func handleOnCrouchChanged(_inIsCrouching : bool) -> void:
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

	var direction : Vector2 = getStateManager().getLastInputDirection()
	var directionVec3 : Vector3 = Vector3(direction.x, 0.0, direction.y)
	var addedVelocity : Vector3 = character.global_transform.basis * directionVec3 * acceleration * delta

	character.velocity += addedVelocity

	if character.is_on_floor() or character.is_on_wall():
		if is_zero_approx(direction.length_squared()):
			character.velocity += getFriction(character.velocity, delta)
		else:
			character.velocity += getFriction(character.velocity, delta, true)

	character.velocity = clampVelocityPlanar(character.velocity, delta)
	character.move_and_slide()

	handleRigidBodyCollisions()

func handleRigidBodyCollisions() -> void:
	var character : Character = Character.getOwningCharacter(self)
	if !character:
		push_error("Must be used on type Character")
		return

	var collisionIndex : int = -1
	var rigidCollider : RigidBody3D = null
	var foundCollision : KinematicCollision3D = null

	for i : int in character.get_slide_collision_count():
		var collision : KinematicCollision3D = character.get_slide_collision(i)
		var colliderAsRigid : RigidBody3D = collision.get_collider() as RigidBody3D
		if !colliderAsRigid:
			continue

		foundCollision  = collision
		rigidCollider = colliderAsRigid
		collisionIndex = i
		break

	if collisionIndex == -1:
		return

	var pushStrength : float = character.mass * character.get_position_delta().length()
	var pushForce : Vector3 = pushStrength * -foundCollision.get_normal(collisionIndex)
	rigidCollider.apply_impulse(pushForce, foundCollision.get_position())

func clampVelocityPlanar(inVelocity : Vector3, delta : float) -> Vector3:
	var velocity2D : Vector2 = Vector2(inVelocity.x, inVelocity.z)
	velocity2D = lerp(velocity2D, velocity2D.limit_length(maxSpeed), maxSpeedEnforcement * delta)
	var result : Vector3 = Vector3(velocity2D.x, inVelocity.y, velocity2D.y)

	return result

func getFriction(inVelocity : Vector3, inDelta : float, isAccelerating : bool = false) -> Vector3:
	var speed : float = inVelocity.length()

	var scaledFriction : float = friction if isAccelerating else friction * slowingFrictionScalar
	var totalFriction : Vector3 = clamp(inDelta * scaledFriction, 0.0, speed) * -inVelocity.normalized()
	var planarizedFriction : Vector3 = Vector3(totalFriction.x, 0.0, totalFriction.z)

	return planarizedFriction

func applyGravity(delta : float) -> void:
	if not getStateManager().getCharacter().is_on_floor():
		getStateManager().getCharacter().velocity += gravity * Vector3.DOWN * delta

func getStateManager() -> CharacterStateManager:
	return get_parent() as CharacterStateManager

func getLeanDirection() -> Vector2:
	return Vector2(getStateManager().getLastInputDirection().x, 0)
