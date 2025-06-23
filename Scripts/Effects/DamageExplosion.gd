extends Node3D
class_name DamageExplosion

@export_category("Config")
@export var damage : float = 30.0
@export var knockbackStrength : float = 14.0
@export var falloffCurve : CurveTexture

@export_category("Ref")
@export var explosionArea : Area3D
@export var animationPlayer : AnimationPlayer

const growAreaAnimationKey : String = "Grow"

const size : float = 9.0
const verticalKnockbackScalar : float = 0.9

var hitCharacters : Array[Character]
var sourceCharacter : Character = null

func injectSourceCharacter(inCharacter : Character) -> void:
	hitCharacters.append(inCharacter)

func _ready() -> void:
	assert(animationPlayer)

	animationPlayer.play(growAreaAnimationKey)

	Util.safeConnect(explosionArea.body_entered, on_body_entered)

func on_body_entered(inBody : PhysicsBody3D) -> void:
	var character : Character = inBody as Character
	if !character:
		return

	if hitCharacters.has(character):
		return

	hitCharacters.append(character)

	var vectorToBody : Vector3 = inBody.global_position - global_position
	var falloff : float = falloffCurve.curve.sample_baked(vectorToBody.length() / size)

	var adjustedVector : Vector3 = vectorToBody.normalized() + (Vector3.UP * verticalKnockbackScalar)

	var knockBack : Vector3 = adjustedVector.normalized() * knockbackStrength * falloff

	character.addVelocity(knockBack)

	var health : Health = Util.getChildOfType(character, Health)
	if health:
		health.takeDamage(damage * falloff)
