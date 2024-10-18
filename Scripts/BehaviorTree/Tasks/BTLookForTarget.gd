extends BTNode
class_name BTLookForTarget

@export_category("Config")
@export var taskDuration : float = 5.0
@export var lookValuesYaw : Array[float] = [-PI/6.0, PI/12.0, -PI/8.0, PI/4.0, -PI/4.0]
@export var lookValuesPitch : Array[float] = [PI/16.0, 0.0, -PI/20.0, 0.0, 0.0]

@onready var taskDurationTimer : Timer = Timer.new()
@onready var lookChangeTimer : Timer = Timer.new()

const lookChangeTimeout : float = 1.75
const lookVectorLength : float = 10.0

var currentIndexYaw : int = 0
var currentIndexPitch : int = 0

func _ready() -> void:
	add_child(taskDurationTimer)
	taskDurationTimer.wait_time = taskDuration
	Util.safeConnect(taskDurationTimer.timeout, on_taskDurationTimer_timeout)

	add_child(lookChangeTimer)
	lookChangeTimer.wait_time = lookChangeTimeout
	Util.safeConnect(lookChangeTimer.timeout, on_lookChangeTimer_timeout)

func on_taskDurationTimer_timeout() -> void:
	if !isNodeActive():
		return

	var behaviorTree : BehaviorTree = Util.getParentInTreeOfType(self, BehaviorTree)
	if !behaviorTree:
		return

	behaviorTree.interrupt()


func on_lookChangeTimer_timeout() -> void:
	if !isNodeActive():
		return

	currentIndexYaw += 1
	currentIndexPitch += 1
	if currentIndexYaw >= lookValuesYaw.size():
		currentIndexYaw = 0

	if currentIndexPitch >= lookValuesPitch.size():
		currentIndexPitch = 0

func updateNode(_inDelta : float) -> BTTickResult:
	if taskDurationTimer.is_stopped():
		taskDurationTimer.start()

	if lookChangeTimer.is_stopped():
		lookChangeTimer.start()

	var rotatedDirection : Vector3 = Vector3.FORWARD.rotated(Vector3.UP, lookValuesYaw[currentIndexYaw])
	rotatedDirection = rotatedDirection.rotated(Vector3.RIGHT, lookValuesPitch[currentIndexPitch])

	var addedPosition : Vector3 = owningCharacter.global_basis * rotatedDirection * lookVectorLength
	targeter.forceUpdatePositionOfInterest(owningCharacter.getHeadGlobalPosition() + addedPosition)

	if targeter.acquireTarget():
		return succeed()

	return run()
