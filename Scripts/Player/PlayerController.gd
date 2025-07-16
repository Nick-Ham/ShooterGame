extends Controller
class_name PlayerController

@export_category("Config")
@export var fpsViewCamera : FPSView
@export var neck : Node3D

static var MOUSE_SENSITIVITY_CONST : float = .001

@export_category("MouseSensitivity")
@export var mouseSensitivity : float = 2.0

@export_subgroup("IndividualAxisSensitivity")
@export var horizontalSensitivity : float = 1.0
@export var verticalSensitivity : float = 1.0

#@export_category("JoyStickSensitivity")
#@export var joystickSensitivity : float = 1.0

var character : CharacterBody3D = null
var isShooting : bool = false

@onready var playerHudScene : PackedScene = preload("res://Scenes/UI/PlayerHUD.tscn")

var playerHud : PlayerHUD = null

func _ready() -> void:
	if !character:
		character = get_parent() as CharacterBody3D

	assert(character, "PlayerController requires a parent Character parent to function")
	assert(fpsViewCamera, "PlayerController requires an FPSViewCamera to function")
	assert(neck, "PlayerController requires a neck pivot to function")

	playerHud = playerHudScene.instantiate()
	playerHud.injectPlayer(character)
	playerHud.initializeMenu(get_tree())

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var rotationY : float = -event.relative.x * MOUSE_SENSITIVITY_CONST * mouseSensitivity * horizontalSensitivity
		var rotationX : float = -event.relative.y * MOUSE_SENSITIVITY_CONST * mouseSensitivity * verticalSensitivity

		character.rotate_y(rotationY)

		var maxRotation : float = .95 * PI/2.0

		neck.rotation.x = clampf(neck.rotation.x + rotationX, -maxRotation, maxRotation)

	if event.is_action_pressed("Shoot"):
		shoot_changed.emit(true)

	if event.is_action_released("Shoot"):
		shoot_changed.emit(false)

	if event.is_action_pressed("Jump"):
		jump_changed.emit(true)

	if event.is_action_released("Jump"):
		jump_changed.emit(false)

	if event.is_action_pressed("Crouch"):
		crouch_changed.emit(true)

	if event.is_action_released("Crouch"):
		crouch_changed.emit(false)

	if event.is_action_pressed("Reload"):
		reload_changed.emit(true)

	if event.is_action_released("Reload"):
		reload_changed.emit(false)

	if event.is_action_pressed("Interact"):
		interact_changed.emit(true)

	if event.is_action_released("Interact"):
		interact_changed.emit(false)

	if event.is_action_pressed("Weapon1"):
		weapon1_triggered.emit()

	if event.is_action_pressed("Weapon2"):
		weapon2_triggered.emit()

	if event.is_action_pressed("Weapon3"):
		weapon3_triggered.emit()

	if event.is_action_pressed("Weapon4"):
		weapon4_triggered.emit()

	if event.is_action_pressed("Weapon5"):
		weapon5_triggered.emit()

func _process(_delta: float) -> void:
	inputDirection = Vector2()
	inputDirection = Input.get_vector("Left", "Right", "Forward", "Backward")
	input_direction_changed.emit(inputDirection)
	isShooting = Input.is_action_pressed("Shoot")

func getIsShooting() -> bool:
	return isShooting

func getAimDirection() -> Vector3:
	return fpsViewCamera.getCameraFacing() * Vector3.FORWARD

func getInputDirection() -> Vector2:
	return inputDirection

func getAimCastResult(inBloom : float = 0.0) -> RayCastResult:
	return fpsViewCamera.getCameraCastResult(inBloom)

static func getController(inNode : Node) -> Controller:
	var controller : Controller = null

	for child : Node in inNode.get_children():
		controller = child as Controller
		if controller != null:
			return controller

	return controller
