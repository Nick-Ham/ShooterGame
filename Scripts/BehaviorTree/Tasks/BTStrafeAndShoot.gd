extends BTNode
class_name BTStrafeAndShoot

@export_category("Config")
@export var taskDuration : float = 2.5
@export var randomDirectionChangeTimeRange : Vector2 = Vector2(0.5, 4.5)
@export var shootPattern : AIShootPattern

@export_group("WallDetection")
@export var useWallDetection : bool = true
@export var leftWallDetector : RayCast3D
@export var rightWallDetector : RayCast3D

@export_group("FloorDetection")
@export var useFloorDetection : bool = true
@export var leftFloorDetector : RayCast3D
@export var rightFloorDetector : RayCast3D

var isMovingLeft : bool = false
var isTimeUp : bool = false

@onready var taskDurationTimer : Timer = Timer.new()
@onready var directionChangeTimer : Timer = Timer.new()
@onready var shootController : AIShootController = Util.getChildOfType(owningCharacter, AIShootController)

func _ready() -> void:
	if useWallDetection:
		assert(leftWallDetector)
		assert(rightWallDetector)

	if useFloorDetection:
		assert(leftFloorDetector)
		assert(rightFloorDetector)

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

	if useWallDetection:
		runWallDetection()

	if useFloorDetection:
		runFloorDetection()

	var moveDirection : Vector2 = Vector2.LEFT if isMovingLeft else Vector2.RIGHT
	controller.setControlDirectionSmooth(moveDirection, inDelta)

	shootController.addPattern(shootPattern)

	return run()

func runWallDetection() -> void:
	if isMovingLeft and leftWallDetector.is_colliding():
		isMovingLeft = false
		return

	if !isMovingLeft and rightWallDetector.is_colliding():
		isMovingLeft = true
		return

func runFloorDetection() -> void:
	if isMovingLeft and !leftFloorDetector.is_colliding():
		isMovingLeft = false
		return

	if !isMovingLeft and !rightFloorDetector.is_colliding():
		isMovingLeft = true
		return
