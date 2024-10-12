extends Controller
class_name AIController

@export_category("Ref")
@export var navAgent : NavigationAgent3D

@export_category("Config")
@export var characterRotationSpeed : float = 3.0
@export var maxAngleFromTarget : float = PI/4.0
@export var controlDirectionLerpSpeed : float = 3.0

@export_category("Navigation")
@export var chaseDistance : float = 0.5

var target : Character = null
var navDirection : Vector2 = Vector2()

var isNavSetup : bool = false

func _ready() -> void:
	navAgent.path_desired_distance = 0.5
	navAgent.target_desired_distance = chaseDistance

	setupNavigation.call_deferred()

func setupNavigation() -> void:
	await get_tree().physics_frame

	isNavSetup = true

func _physics_process(delta: float) -> void:
	rotateCharacterToTarget(delta)

	if target:
		updateNavTarget(getTargetPosition())

func getDirectionFromNavigation() -> Vector2:
	if !isNavSetup:
		return Vector2()

	if navAgent.is_navigation_finished():
		return Vector2()

	var parentCharacter : Character = get_parent() as Character
	var currentPosition : Vector3 = parentCharacter.global_position
	var nextPathPosition : Vector3 = navAgent.get_next_path_position()

	var direction : Vector3 = currentPosition.direction_to(nextPathPosition) * parentCharacter.global_basis
	return Vector2(direction.x, direction.z)

func updateNavTarget(inGlobalPosition : Vector3) -> void:
	navAgent.target_position = inGlobalPosition

func rotateCharacterToTarget(inDelta : float) -> void:
	if !target:
		return

	var character : Character = get_parent()
	var characterForward : Vector3 = character.global_basis * Vector3.BACK
	var characterForward2D : Vector2 = Vector2(characterForward.x, characterForward.z)

	var vectorToTarget : Vector3 = character.global_position - getTargetPosition()
	var vectorToTarget2D : Vector2 = Vector2(vectorToTarget.x, vectorToTarget.z)

	var angleToTarget : float = vectorToTarget2D.normalized().angle_to(characterForward2D.normalized())

	if is_zero_approx(character.velocity.length_squared()) and abs(angleToTarget) < maxAngleFromTarget:
		return

	character.rotate_y(angleToTarget * inDelta * characterRotationSpeed)

func getTarget() -> Node3D:
	return target

func getTargetPosition() -> Vector3:
	if !target:
		return Vector3()

	var targetAsCharacter : Character = target as Character
	if targetAsCharacter:
		return targetAsCharacter.getHeadGlobalPosition()

	return target.global_position

func setControlDirectionSmooth(inDirection : Vector2, inDelta : float) -> void:
	var newInputDirection : Vector2 = inDirection.normalized()
	inputDirection = lerp(inputDirection, newInputDirection, inDelta * controlDirectionLerpSpeed)
	input_direction_changed.emit(inputDirection)

func setControlDirection(inDirection : Vector2) -> void:
	inputDirection = inDirection.normalized()
	input_direction_changed.emit(inputDirection)

func turn(inAmount : float) -> void:
	var character : Character = get_parent()
	character.rotate_y(inAmount)
