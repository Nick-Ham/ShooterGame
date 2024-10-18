extends Node
class_name AIShootController

var currentPatternName : String = ""
var currentPattern : Array[float]
var currentPosition : int = 0

var totalTime : float = 0.0

func _physics_process(delta : float) -> void:
	if currentPattern.size() == 0:
		return

	totalTime += delta

	var timeToNextShot : float = currentPattern[currentPosition]
	if !totalTime > timeToNextShot:
		return

	totalTime -= timeToNextShot
	shoot()

	currentPosition += 1
	currentPosition = currentPosition % currentPattern.size()

func shoot() -> void:
	var controller : AIController = Util.getChildOfType(get_parent(), AIController)
	if !controller:
		return

	controller.shoot()

func addPattern(inPattern : AIShootPattern) -> void:
	if inPattern.patternName == "":
		push_warning("ShootPattern with no defined name will be ignored")
		return

	if inPattern.patternName == currentPatternName:
		return

	currentPatternName = inPattern.patternName
	currentPattern = inPattern.shotPattern.duplicate()

	totalTime = 0

	currentPosition = 0
	if inPattern.useRandomInitialPosition:
		currentPosition = randi_range(0, inPattern.shotPattern.size() - 1)

	if currentPattern.size() == 0:
		return

	shoot()
