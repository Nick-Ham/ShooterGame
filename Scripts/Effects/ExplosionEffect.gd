extends Node3D
class_name ExplosionEffect

@export_category("Ref")
@export var animationPlayer : AnimationPlayer

const explodeAnimationKey : String = "Explode"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("F3"):
		explode()

func _ready() -> void:
	explode()

func explode() -> void:
	if animationPlayer.is_playing():
		return

	animationPlayer.play(explodeAnimationKey)
