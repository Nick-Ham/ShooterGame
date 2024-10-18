extends BTNode
class_name BTStrafeAndShoot

@export_category("Config")
@export var taskDuration : float = 2.5
@export var randomDirectionChangeTimeRange : Vector2 = Vector2(0.5, 2.5)
@export var shootPattern : AIShootPattern

var isMovingLeft : bool = false
var isTimeUp : bool = false

@onready var taskDurationTimer : Timer = Timer.new()
@onready var directionChangeTimer : Timer = Timer.new()
@onready var shootController : AIShootController = Util.getChildOfType(owningCharacter, AIShootController)

func _ready() -> void:
	add_child(taskDurationTimer)
	taskDurationTimer.autostart = false
	taskDurationTimer.wait_time = taskDuration
	Util.safeConnect(taskDurationTimer.timeout, on_taskDurationTimer_timeout)

	add_child(directionChangeTimer)
	directionChangeTimer.autostart = false
	Util.safeConnect(directionChangeTimer.timeout, on_directionChangeTimer_timeout)

func on_taskDurationTimer_timeout() -> void:
	if isNodeActive():
		isTimeUp = true

func on_directionChangeTimer_timeout() -> void:
	isMovingLeft = !isMovingLeft

func updateNode(inDelta : float) -> BTTickResult:
	if isTimeUp:
		isTimeUp = false
		return succeed()

	if taskDurationTimer.is_stopped():
		taskDurationTimer.start()

	if directionChangeTimer.is_stopped():
		var randTime : float = randf_range(randomDirectionChangeTimeRange.x, randomDirectionChangeTimeRange.y)
		directionChangeTimer.start(randTime)

	var controller : AIController = Util.getChildOfType(owningCharacter, AIController)
	if !controller:
		push_warning("BTNode running without an AIController")
		return fail()

	var moveDirection : Vector2 = Vector2.LEFT if isMovingLeft else Vector2.RIGHT
	controller.setControlDirectionSmooth(moveDirection, inDelta)

	shootController.addPattern(shootPattern)

	return run()
