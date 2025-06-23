extends NavigationAgent3D
class_name NavigationController

@export_category("Config")
@export var chaseDistance : float = 0.5

var navDirection : Vector2 = Vector2()
var isNavSetup : bool = false

func _ready() -> void:
	path_desired_distance = 1.0
	target_desired_distance = chaseDistance

	setupNavigation.call_deferred()

func _physics_process(_delta: float) -> void:
	get_next_path_position()

func updateNavTarget(inGlobalPosition : Vector3) -> void:
	target_position = inGlobalPosition

func setupNavigation() -> void:
	await get_tree().physics_frame

	isNavSetup = true

func getDirectionFromNavigation() -> Vector2:
	if !isNavSetup:
		return Vector2()

	if is_navigation_finished():
		return Vector2()

	var parentCharacter : Character = get_parent() as Character
	var currentPosition : Vector3 = parentCharacter.global_position
	var nextPathPosition : Vector3 = get_next_path_position()

	var direction : Vector3 = currentPosition.direction_to(nextPathPosition) * parentCharacter.global_basis
	return Vector2(direction.x, direction.z)

func getNextNavigationPoint() -> Vector3:
	return get_next_path_position()

func getTargetPosition() -> Vector3:
	return target_position
