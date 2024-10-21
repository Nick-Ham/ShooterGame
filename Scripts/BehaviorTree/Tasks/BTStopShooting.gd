extends BTNode
class_name BTStopShooting

@onready var emptyPattern : AIShootPattern = preload("res://Data/ShootPatterns/StopShooting.tres")

func updateNode(_inDelta : float) -> BTTickResult:
	var shootController : AIShootController = Util.getChildOfType(owningCharacter, AIShootController)
	if !shootController:
		push_warning("Shoot based BTNode requires shootcontroller")
		return fail()

	shootController.addPattern(emptyPattern)
	return succeed()
