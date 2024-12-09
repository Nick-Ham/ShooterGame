extends Node3D
class_name Impact

@export_category("Config")
@export var pivot : Node3D
@export var useParticles : bool = true

@export_category("Ref")
@export var decal : Decal
@export var particlesScene : PackedScene
@export var impactPlayer : AudioStreamPlayer3D

@export var delayFadeTimer : Timer
@export var fadeDurationTimer : Timer

var particlesInstance : GPUParticles3D = null
var delayFadeEnded : bool = false

const particleChance : float = 1.0 #0.65

func _ready() -> void:
	pivot.transform = pivot.transform.rotated(Vector3.FORWARD, randf_range(0.0, PI * 2))

	if decal:
		decal.sorting_offset = 1.5

	if !randf() > particleChance and useParticles:
		spawnParticles()

	if impactPlayer:
		impactPlayer.play()

	Util.safeConnect(delayFadeTimer.timeout, on_delayFade_timeout)
	Util.safeConnect(fadeDurationTimer.timeout, on_fadeDuration_timeout)

func _process(_delta: float) -> void:
	if !delayFadeEnded:
		return

	if decal:
		decal.modulate.a = fadeDurationTimer.time_left / fadeDurationTimer.wait_time

func on_delayFade_timeout() -> void:
	delayFadeEnded = true
	fadeDurationTimer.start()

func on_fadeDuration_timeout() -> void:
	queue_free()

func spawnParticles() -> void:
	particlesInstance = particlesScene.instantiate() as GPUParticles3D
	pivot.add_child(particlesInstance)
	particlesInstance.transform = Transform3D()
	particlesInstance.emitting = true

	var onParticlesFinished : Callable = func() -> void:
		particlesInstance.queue_free()

	Util.safeConnect(particlesInstance.finished, onParticlesFinished)
