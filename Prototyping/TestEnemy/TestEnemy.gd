extends Character
class_name TestEnemy

@export_category("Ref")
@export var modelAnimationTree : AnimationTree

var direction : Vector3 = Vector3()
var speed : float = 2.0
var directionSpeed : float = 6.0
var turnSpeed : float = 1.0

@export var target : Node3D = null

const minChastDistance : float = 3.0

func _ready() -> void:
	modelAnimationTree.set("parameters/MoveDirection/blend_position", Vector2())

func _process(_delta: float) -> void:
	direction = Vector3.RIGHT

	modelAnimationTree.set("parameters/MoveDirection/blend_position", Vector2(direction.x, direction.z))


func _physics_process(_delta: float) -> void:
	move_and_slide()
