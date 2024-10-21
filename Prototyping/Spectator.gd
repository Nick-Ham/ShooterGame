extends Node3D
class_name Spectator

@export_category("Ref")
@export var cinemaCam : Camera3D

@export_category("Category")
@export var moveSpeed : float = 5.0

@export_category("MouseSensitivity")
@export var mouseSensitivity : float = 2.0

@export_subgroup("IndividualAxisSensitivity")
@export var horizontalSensitivity : float = 1.0
@export var verticalSensitivity : float = 1.0

static var MOUSE_SENSITIVITY_CONST : float = .001

const engineSpeedStep : float = 0.05
var targetEngineSpeed : float = 1.0:
	set(inSpeed):
		targetEngineSpeed = clampf(inSpeed, 0.05, 1.5)
		Engine.time_scale = targetEngineSpeed

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("F2"):
		cinemaCam.current = !cinemaCam.current

	if event is InputEventMouseMotion:
		var rotationY : float = -event.relative.x * MOUSE_SENSITIVITY_CONST * mouseSensitivity * horizontalSensitivity
		var rotationX : float = -event.relative.y * MOUSE_SENSITIVITY_CONST * mouseSensitivity * verticalSensitivity

		rotate_y(rotationY)

		var maxRotation : float = .95 * PI/2.0

		cinemaCam.rotation.x = clampf(cinemaCam.rotation.x + rotationX, -maxRotation, maxRotation)

	if event.is_action_pressed("EngineSpeedUp"):
		targetEngineSpeed += engineSpeedStep

	if event.is_action_pressed("EngineSpeedDown"):
		targetEngineSpeed -= engineSpeedStep

func _physics_process(delta: float) -> void:
	var direction : Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	var upDownDirection : float = Input.get_axis("Crouch", "Jump")

	var direction3D : Vector3 = Vector3(direction.x, upDownDirection, direction.y)

	global_position += cinemaCam.global_basis * direction3D * delta * moveSpeed * pow(Engine.time_scale, -1)
