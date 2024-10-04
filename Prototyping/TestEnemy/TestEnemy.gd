extends CharacterBody3D
class_name TestEnemy

var direction : Vector3 = Vector3()
var speed : float = 2.0

func _process(_delta: float) -> void:
	direction.x = sin(Time.get_ticks_msec() / 1000.0 * 2.0)

func _physics_process(_delta: float) -> void:
	velocity = direction * speed

	move_and_slide()
