extends Node3D
class_name ExplosionEffect

@export_category("Ref")
@export var animationPlayer : AnimationPlayer
@export var explosionAudioPlayer : AudioStreamPlayer3D

const explodeAnimationKey : String = "Explode"

var intensity : float = 1.0
var audioIntensityScalar : float = 10.0

func _ready() -> void:
	assert(animationPlayer)
	assert(explosionAudioPlayer)

	explode()

func updateIntensity(inIntensity : float) -> void:
	intensity = inIntensity

	scale *= intensity
	explosionAudioPlayer.volume_db += (intensity - 1.0) * audioIntensityScalar

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("F3"):
		explode()

func explode() -> void:
	if animationPlayer.is_playing():
		return

	animationPlayer.play(explodeAnimationKey)
