extends Node
class_name SmallRobotFlamethrowerController

@export_category("Ref")
@export var flamethrowerParticle : GPUParticles3D
@export var flamethrowerHitbox : Area3D
@export var flamethrowerSoundLoopPlayer : AudioStreamPlayer3D

@export_category("Config")
@export var damagePerSecond : float = 15.0

@onready var character : Character = Character.getOwningCharacter(self)
@onready var damage : Damage = Damage.new()
@onready var controller : AIController = Util.getChildOfType(character, AIController)
@onready var targeter : Targeter = Util.getChildOfType(character, Targeter)

var isShooting : bool = false
var shotLastFrame : bool = false

const flamethrowerMaxAudio : float = -20.0
const flamethrowerMinAudio : float = -80.0

const flamethrowerAudioLerpSpeed : float = 15.0

func _ready() -> void:
	assert(flamethrowerParticle)
	assert(flamethrowerHitbox)
	assert(flamethrowerSoundLoopPlayer)

	add_child(damage)

	flamethrowerParticle.emitting = false

	Util.safeConnect(controller.shoot_changed, on_shoot_changed)

func _physics_process(delta: float) -> void:
	updateFlamethrowerAudio(delta)

	shotLastFrame = false

	if !isShooting:
		return

	var hitAreas : Array[Area3D] = flamethrowerHitbox.get_overlapping_areas()
	var hitCharacters : Array[Character] = []
	for hitArea : Area3D in hitAreas:
		var owningCharacter : Character = Character.getOwningCharacter(hitArea)

		if hitCharacters.has(owningCharacter):
			continue

		hitCharacters.append(owningCharacter)

	if !Util.isValid(targeter):
		return

	if !targeter.hasTarget() or !hitCharacters.has(targeter.getTarget() as Character):
		return

	flamethrowerParticle.emitting = true
	shotLastFrame = true

	damage.damage = damagePerSecond * delta
	for hitCharacter : Character in hitCharacters:
		damage.dealDamage(hitCharacter, character)

func updateFlamethrowerAudio(inDelta : float) -> void:
	var targetVolume : float = flamethrowerMaxAudio if shotLastFrame else flamethrowerMinAudio

	flamethrowerSoundLoopPlayer.volume_db = lerp(flamethrowerSoundLoopPlayer.volume_db, targetVolume, flamethrowerAudioLerpSpeed * inDelta)

func on_shoot_changed(inIsShooting : bool) -> void:
	isShooting = inIsShooting
	if !isShooting:
		flamethrowerParticle.emitting = false

func disable() -> void:
	isShooting = false
	flamethrowerSoundLoopPlayer.stop()
	flamethrowerParticle.emitting = false
