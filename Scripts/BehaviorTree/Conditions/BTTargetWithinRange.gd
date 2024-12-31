extends BTNode
class_name BTTargetWithinRange

@export_category("Config")
@export var targetDistance : float = 0.5

func updateNode(_inDelta : float) -> BTTickResult:
	if !targeter.hasTarget():
		return fail()

	var distanceSquaredToTarget : float = owningCharacter.global_position.distance_squared_to(targeter.target.global_position)
	if distanceSquaredToTarget < pow(targetDistance, 2):
		return succeed()

	return fail()
