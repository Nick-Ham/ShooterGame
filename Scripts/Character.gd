extends CharacterBody3D
class_name Character

@export_category("CharacterConfig")
@export var headHeight : float = 1.5
@export var minShootAngle : float = PI/10.0
@export var characterRotationSpeed : float = 3.0
@export var maxAngleFromTarget : float = PI/3.0

@export_category("Team")
@export_enum("TEAM1", "TEAM2") var team : int = 0

@export_category("Ref")
@export var aimMarker : Marker3D
@export var aimCast : RayCast3D

@export_category("Aim")
@export var aimingAtTolerance : float = PI/8.0

signal character_destroyed(character : Character)

var isDestroyed : bool = false

var decayTimer : SceneTreeTimer

func destroyCharacter() -> void:
	isDestroyed = true
	character_destroyed.emit(self)

	await get_tree().create_timer(20.0).timeout
	queue_free()

func getIsDestroyed() -> bool:
	return isDestroyed

func getHeadHeight() -> float:
	return headHeight

func getHeadGlobalPosition() -> Vector3:
	var headPosition : Vector3 = global_position
	headPosition.y += getHeadHeight()
	return headPosition

static func getOwningCharacter(inNode : Node) -> Character:
	if inNode == null:
		return null

	var currentParent : Node = inNode
	while currentParent != inNode.get_tree().root:
		currentParent = currentParent.get_parent()

		var asCharacter : Character = currentParent as Character
		if is_instance_valid(asCharacter):
			break

	return currentParent

func isAimingAt(inPosition : Vector3) -> bool:
	var directionToTarget : Vector3 = (aimMarker.global_position - inPosition).normalized()
	var angleToDirection : float = (aimMarker.global_transform.basis * Vector3.BACK).angle_to(directionToTarget)

	if angleToDirection > aimingAtTolerance:
		return false

	return true

func canSee(inTarget : Node3D, inAngleTolerance : float = PI, useCharacterForward : bool = false) -> bool:
	if !is_instance_valid(inTarget):
		return false

	var targetPosition : Vector3 = inTarget.global_position

	var targetAsCharacter : Character = inTarget as Character
	if targetAsCharacter:
		targetPosition = targetAsCharacter.getHeadGlobalPosition()

	var transformReference : Transform3D = global_transform if useCharacterForward else aimMarker.global_transform
	var angleToPosition : float = getAngleToPosition(transformReference, targetPosition)
	if angleToPosition > abs(inAngleTolerance):
		return false

	var distanceToTarget : float = aimMarker.global_position.distance_to(targetPosition)

	aimCast.target_position = Vector3(0, 0, -distanceToTarget)
	aimCast.look_at(targetPosition)

	aimCast.force_raycast_update()

	if aimCast.is_colliding():
		return false

	return true

func getAngleToPosition(inTransform : Transform3D, targetPosition : Vector3) -> float:
	var relativeTargetPosition : Vector3 = targetPosition * inTransform
	var angle : float = Vector3.FORWARD.angle_to(relativeTargetPosition)
	return angle

func rotateCharacterToTarget(inTarget : Vector3, inDelta : float) -> void:
	var characterForward : Vector3 = global_basis * Vector3.BACK
	var characterForward2D : Vector2 = Vector2(characterForward.x, characterForward.z)

	var vectorToTarget : Vector3 = global_position - inTarget
	var vectorToTarget2D : Vector2 = Vector2(vectorToTarget.x, vectorToTarget.z)

	var angleToTarget : float = vectorToTarget2D.normalized().angle_to(characterForward2D.normalized())

	if is_zero_approx(velocity.length_squared()) and abs(angleToTarget) < maxAngleFromTarget:
		return

	rotate_y(angleToTarget * inDelta * characterRotationSpeed)

func addVelocity(inVelocity : Vector3) -> void:
	velocity += inVelocity
