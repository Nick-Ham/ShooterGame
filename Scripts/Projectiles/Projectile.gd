extends CharacterBody3D
class_name Projectile

@export_category("Ref")
@export var damage : Damage
@export var shapeCast : ShapeCast3D

@export_category("Config")
@export var speed : float = 40.0

var projection : Vector3 = Vector3.FORWARD * speed * (1.0 / Engine.physics_ticks_per_second)

func _ready() -> void:
	assert(damage)

	shapeCast.target_position = projection
	shapeCast.collision_mask = 9

func _physics_process(_delta: float) -> void:
	projectShape()

	velocity = global_basis * Vector3.FORWARD * speed
	var collided : bool = move_and_slide()

	if !collided:
		return

	handleCollision()

func projectShape() -> void:
	if !shapeCast.is_colliding():
		return

	var collider : Object = shapeCast.get_collider(0)
	var colliderAsHitbox : Hitbox = collider as Hitbox
	if !colliderAsHitbox:
		return

	var newRayCastResult : RayCastResult = RayCastResult.new()
	newRayCastResult.hitSuccess = true
	newRayCastResult.collider = collider as Object
	newRayCastResult.hitPosition = shapeCast.get_collision_point(0)
	newRayCastResult.hitNormal = shapeCast.get_collision_normal(0)
	newRayCastResult.rayOrigin = shapeCast.global_position

	newRayCastResult.collider = colliderAsHitbox
	handleHitEnemy(newRayCastResult)

	queue_free()

func handleHitEnemy(hitResult : RayCastResult) -> void:
	damage.dealDamage(Character.getOwningCharacter(hitResult.collider))
	var hitBox : Hitbox = hitResult.collider as Hitbox
	if hitBox:
		hitBox.addImpact(hitResult.hitPosition, hitResult.hitNormal)

func handleHitEnvironment(rayCastResult : RayCastResult) -> void:
	var game : Game = get_tree().current_scene as Game
	var level : Level = game.getLevel()
	var environmentalEffectManager : EnvironmentEffectManager = level.getEnvironmentalEffectManager()

	environmentalEffectManager.addBulletImpact(rayCastResult.hitPosition, rayCastResult.hitNormal)

func handleCollision() -> void:
	var collision : KinematicCollision3D = get_slide_collision(0)
	if !collision:
		return

	var newRayCastResult : RayCastResult = RayCastResult.new()
	newRayCastResult.hitSuccess = true
	newRayCastResult.collider = collision.get_collider() as Object
	newRayCastResult.hitPosition = collision.get_position()
	newRayCastResult.hitNormal = collision.get_normal()
	newRayCastResult.rayOrigin = global_position

	handleHitEnvironment(newRayCastResult)

	queue_free()