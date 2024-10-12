extends Node
class_name HeadBob

@export_category("Config")
@export var isPrimary : bool = true
@export var target : Node3D
@export var stateManager : CharacterStateManager
@export var amplitudeY : float = 0.05
@export var amplitudeX : float = 0.03
@export var period : float = 5.0

## Multiplied against delta. Clamped per-tick to 1.0
@export var lerpConstant : float = 10.0

var currentSettings : HeadBobSettings = null

signal step_taken(bIsLeft : bool)
const msecToSec : float = PI / 1000.0
const minimumStepTime : float = 0.2

var canStep : bool = false
var timeMoving : float = 0.0

func _enter_tree() -> void:
	assert(target, "Must have a target in order to function" + str(self.name))
	assert(stateManager, "Must have a CharacterStateManager in order to function" + str(self.name))

	target.position = Vector3()

	var on_state_changed : Callable = func (_lastState : CharacterState, _newState : CharacterState) -> void:
		loadCurrentHeadBobSettings()

	Util.safeConnect(stateManager.state_changed, on_state_changed)

func _physics_process(delta: float) -> void:
	updateHeadBob(delta)

func updateHeadBob(inDelta : float) -> void:
	var offset : Vector2 = getTotalOffset(stateManager.getCurrentSpeed(), stateManager.getCurrentMaxSpeed())

	checkStep(inDelta)

	var offsetAsVec3 : Vector3 = Vector3(offset.x, offset.y, 0)
	target.position = lerp(target.position, offsetAsVec3, clampf(lerpConstant * inDelta, 0.0, 1.0))

func getTotalOffsetWave() -> Vector2:
	var offset : Vector2 = Vector2()

	if currentSettings == null:
		return offset

	offset.y = sin(Time.get_ticks_msec() * msecToSec * period * currentSettings.periodScalar)
	offset.x = sin(PI / 4 - Time.get_ticks_msec() * msecToSec * period * currentSettings.periodScalar / 2.0)
	return offset

func getTotalOffset(inSpeed : float, inMaxSpeed : float) -> Vector2:
	var offset : Vector2 = Vector2()

	if currentSettings == null:
		return offset

	if inSpeed < stateManager.getMinimumSpeed():
		return offset

	offset = getTotalOffsetWave()

	offset.y *= amplitudeY
	offset.x *= amplitudeX

	offset *= inSpeed / inMaxSpeed
	offset *= currentSettings.amplitudeScalar

	return offset

func loadCurrentHeadBobSettings() -> void:
	var currentState : CharacterState = stateManager.getCurrentState()
	if !currentState:
		return

	currentSettings = null

	for child : Node in currentState.get_children():
		currentSettings = child as HeadBobSettings
		if currentSettings != null:
			return

var lastSign : float = 1.0
func checkStep(inDelta : float) -> void:
	if !stateManager.getCharacter().is_on_floor():
		return

	if !is_zero_approx(stateManager.lastInputDirection.length_squared()):
		timeMoving += inDelta
	else:
		timeMoving = 0.0

	if timeMoving < minimumStepTime:
		return

	if is_zero_approx(stateManager.getCurrentSpeed()):
		return

	var offset : Vector2 = getTotalOffsetWave()

	if signf(offset.x) != lastSign:
		var isLeft : bool = offset.x < 0.0
		step_taken.emit(isLeft)

	lastSign = signf(offset.x)
	return
