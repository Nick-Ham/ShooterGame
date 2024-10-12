extends Node
class_name MathUtil

const USE_LINEAR : bool = true
const GRAVITY_CONSTANT : float = 2.0

static func getForceOfGravity(inMass1 : float, inMass2 : float, inDistance : float) -> float:
	var totalMass : float = inMass1 * inMass2
	var radius : float = pow(inDistance, 1 if USE_LINEAR else 2)

	return GRAVITY_CONSTANT * (totalMass / radius)

static func lerpToVector(inNode : Node3D, upVector : Vector3, inDirectionVector : Vector3, inLerpWeight : float) -> void:
	var forwardVector : Vector3 = -inNode.global_transform.basis.z
	var initialScale : Vector3 = inNode.scale

	var axis : Vector3 = forwardVector.cross(inDirectionVector.normalized()).normalized()
	var angleToTarget : float = acos(forwardVector.dot(inDirectionVector.normalized()))

	var rotationQuat : Quaternion = Quaternion(axis, angleToTarget)

	var currentQuat : Quaternion = inNode.global_transform.basis.get_rotation_quaternion()
	var newQuat : Quaternion = rotationQuat * currentQuat

	inNode.global_transform.basis = Basis(currentQuat.slerp(newQuat, inLerpWeight))
	forwardVector = inNode.global_transform.basis.z

	var rightVector : Vector3 = -upVector.cross(forwardVector).normalized()
	var correctedUpVector : Vector3 = forwardVector.cross(rightVector).normalized()

	inNode.global_transform.basis = Basis(rightVector, correctedUpVector, inDirectionVector.normalized())

	inNode.scale = initialScale

static func lerpLookAt(inNode : Node3D, upVector : Vector3, inGlobalPosition : Vector3, inLerpWeight : float) -> void:
	var inDirectionVector : Vector3 = (inGlobalPosition - inNode.global_position).normalized()
	lerpToVector(inNode, upVector, inDirectionVector, inLerpWeight)
