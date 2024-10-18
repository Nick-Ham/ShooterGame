extends Node
class_name WeaponUtil

static func getBloomedForward(inBloom : float) -> Vector3:
	var resultVector : Vector3 = Vector3.FORWARD

	var pitchAngle : float = randf_range(-1.0, 1.0) * 2 * PI * inBloom
	var yawAngle : float = randf_range(-1.0, 1.0) * 2 * PI * inBloom

	resultVector = resultVector.rotated(Vector3.UP, pitchAngle)
	resultVector = resultVector.rotated(Vector3.RIGHT, yawAngle)

	return resultVector
