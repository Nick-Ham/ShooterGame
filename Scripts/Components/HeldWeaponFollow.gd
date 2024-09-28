extends Node3D
class_name HeldWeaponFollow

@export_category("Config")
## Multiplied by delta, clamped per tick to 1.0. Value should be above 100
@export var gunLerpSpeed : float = 120.0

func _ready() -> void:
	set_as_top_level(true)

func _process(delta : float) -> void:
	global_position = get_parent().global_position

	var targetDirection : Vector3 = -get_parent().global_transform.basis.z
	var angleToTarget : float = (targetDirection).dot(-self.global_transform.basis.z)

	if !is_zero_approx(1.0 - angleToTarget):
		MathUtil.lerpToVector(self, getCharacterUp(), targetDirection, clampf(gunLerpSpeed * delta, 0.0, 1.0))

## This could create issues in the future, in the case that the character ever is allowed to rotate something
## other than its YAW
func getCharacterUp() -> Vector3:
	return Vector3.UP
