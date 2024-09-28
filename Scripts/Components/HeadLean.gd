extends Node
class_name HeadLean

@export_category("Config")
@export var target : Node3D
@export var stateManager : CharacterStateManager

@export var maxLeanDegrees : float = 1.0
## Multiplies against delta. Clamped per tick to 1.0
@export var leanLerpSpeed : float = 5.0

var targetLean : Vector3 = Vector3()

func _ready() -> void:
	assert(stateManager, "CharacterStateManager required in order to function " + str(self.name))
	assert(target, "Must assign target in order to function" + str(self.name))

func _process(delta: float) -> void:
	var leanDirection : Vector2 = stateManager.getCurrentState().getLeanDirection()
	leanDirection *= PI * maxLeanDegrees / 180.0
	targetLean = Vector3(leanDirection.y, 0.0, leanDirection.x)

	target.rotation = lerp(target.rotation, targetLean, clampf(delta * leanLerpSpeed, 0.0, 1.0))
