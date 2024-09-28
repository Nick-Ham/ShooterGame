extends Node
class_name PlayerHeadPunchController

@export_category("Config")
@export var stateManager : CharacterStateManager
@export var stateInAir : CharacterStateInAir
@export var headPunch : Punch

@export_category("StateChangeSettings")
@export var onJumpPunchStrength : Vector2 = Vector2(1.5, 1.75)
@export var onLandPunchStrength : Vector2 = Vector2(1.5, -2.0)
@export var onLandPunchVelocityScalar : float = 1.0

func _ready() -> void:
	assert(stateManager)
	assert(stateInAir)
	assert(headPunch)

	Util.safeConnect(stateManager.state_changed, on_state_changed)

func on_state_changed(inPreviousState : CharacterState, inNewState : CharacterState) -> void:
	if inPreviousState is CharacterStateDefault && inNewState is CharacterStateJumping:
		var randRoll : float = randf_range(-abs(onJumpPunchStrength.x), abs(onJumpPunchStrength.x))
		headPunch.addRotationPunch(Vector3(onJumpPunchStrength.y, 0.0, randRoll))
		return

	if inPreviousState is CharacterStateInAir && inNewState is CharacterStateDefault:
		var punchX : float = 0.0
		var randRoll : float = randf_range(-abs(onLandPunchStrength.x), abs(onLandPunchStrength.x))

		var inputDirectionX : float = stateManager.getCharacterController().getInputDirection().x
		if is_zero_approx(inputDirectionX):
			punchX = randRoll
		else:
			punchX = abs(randRoll) * signf(inputDirectionX)

		var velocityScalar : float = log(stateInAir.getLastVelocity().length() + 1) * onLandPunchVelocityScalar

		headPunch.addRotationPunch(Vector3(onLandPunchStrength.y, 0.0, punchX) * velocityScalar)
		return

	return
