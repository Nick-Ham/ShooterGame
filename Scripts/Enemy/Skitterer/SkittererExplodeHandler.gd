extends Node
class_name SkittererExplodeHandler

@onready var fieryExplosionScene : PackedScene = preload("res://Scenes/Effects/FieryExplosion/FieryExplosion.tscn")
@onready var damageExplosionScene : PackedScene = preload("res://Scenes/Effects/DamageExplosion.tscn")

@export_category("Ref")
@export var animationPlayer : AnimationPlayer

const detonateAnimationKey : String = "Explode"
const onDeathAnimationKey : String = "OnDeath"

@onready var owningCharacter : Character = Character.getOwningCharacter(self)

var hasExploded : bool = false

func _ready() -> void:
	Util.safeConnect(owningCharacter.character_destroyed, on_character_destroyed)

func on_character_destroyed(_inCharacter : Character) -> void:
	explode()

func beginDetonation() -> void:
	animationPlayer.play(detonateAnimationKey)

func explode() -> void:
	if hasExploded:
		return

	hasExploded = true

	var explosion : Explosion = fieryExplosionScene.instantiate()
	var damageExplosion : DamageExplosion = damageExplosionScene.instantiate()

	var level : Level = Game.getGame(get_tree()).getLevel()
	level.add_child(explosion)
	level.add_child(damageExplosion)

	explosion.global_position = owningCharacter.getHeadGlobalPosition()
	damageExplosion.global_position = owningCharacter.getHeadGlobalPosition()

	var controller : AIController = Util.getChildOfType(owningCharacter, AIController)
	if is_instance_valid(controller):
		controller.queue_free()

	owningCharacter.destroyCharacter()
	animationPlayer.play(onDeathAnimationKey)
