extends Node
class_name Punch

@export_category("Config")
@export var target : Node3D
## Multiplied against delta. Clamped to 1.0 per second.
@export var punchLerpSpeed : float = 7.0
@export var punchDecayLerpSpeed : float = 4.0
@export var maxRotation : Vector3 = Vector3(50.0, 5.0, 5.0)
@export var maxTranslation : Vector3 = Vector3(0.05, 0.05, 0.05)

var currentTargetRotation : Vector3 = Vector3()
var currentTargetTranslation : Vector3 = Vector3()

func _process(delta: float) -> void:
	target.rotation_degrees = lerp(target.rotation_degrees, currentTargetRotation, delta * punchLerpSpeed)
	currentTargetRotation = lerp(currentTargetRotation, Vector3(), delta * punchDecayLerpSpeed)

	target.position = lerp(target.position, currentTargetTranslation, delta * punchLerpSpeed)
	currentTargetTranslation = lerp(currentTargetTranslation, Vector3(), delta * punchDecayLerpSpeed)

func addRotationPunch(inPunch : Vector3) -> void:
	currentTargetRotation += inPunch

	currentTargetRotation.x = clampf(currentTargetRotation.x, -abs(maxRotation.x), abs(maxRotation.x))
	currentTargetRotation.y = clampf(currentTargetRotation.y, -abs(maxRotation.y), abs(maxRotation.y))
	currentTargetRotation.z = clampf(currentTargetRotation.z, -abs(maxRotation.z), abs(maxRotation.z))

func addTranslationPunch(inPunch : Vector3) -> void:
	currentTargetTranslation += inPunch

	currentTargetTranslation.x = clampf(currentTargetTranslation.x, -abs(maxTranslation.x), abs(maxTranslation.x))
	currentTargetTranslation.y = clampf(currentTargetTranslation.y, -abs(maxTranslation.y), abs(maxTranslation.y))
	currentTargetTranslation.z = clampf(currentTargetTranslation.z, -abs(maxTranslation.z), abs(maxTranslation.z))
