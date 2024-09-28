extends CharacterState
class_name CharacterStateInAir

@export_category("Config")
@export var landingStateKey : String = "default"

var lastVelocity : Vector3 = Vector3()

func getStateKey() -> String:
	return "inAir"

func update_physics(inDelta : float) -> void:
	var velocity : Vector3 = getStateManager().getCharacter().velocity

	lastVelocity = velocity
	super.update_physics(inDelta)

	if getStateManager().getCharacter().is_on_floor():
		request_change_state.emit(landingStateKey)
		return

func getLastVelocity() -> Vector3:
	return lastVelocity
