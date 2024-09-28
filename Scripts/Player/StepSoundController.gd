extends Node
class_name StepSoundController

@export_category("Config")
@export var audioStreamPlayer : AudioStreamPlayer3D
@export var headBob : HeadBob

func _ready() -> void:
	assert(audioStreamPlayer)
	assert(headBob)

	Util.safeConnect(headBob.step_taken, on_step_taken)

func on_step_taken(_isLeft : bool) -> void:
	audioStreamPlayer.play()
