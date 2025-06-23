extends Explosion
class_name ImpactExplosion

@export_category("Ref")
@export var animationPlayer : AnimationPlayer
@export var smokeParticle : GPUParticles3D
@export var fragmentParticle : GPUParticles3D

const explodeAnimationKey : String = "Explode"

func _ready() -> void:
	assert(animationPlayer)

	explode()

func explode() -> void:
	animationPlayer.play(explodeAnimationKey)
