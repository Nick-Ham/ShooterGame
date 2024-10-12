extends Node
class_name RobotWalkerAnimationController

@export_category("Ref")
@export var modelAnimationTree : AnimationTree
@export var aimPivot : Node3D

@export_category("Config")
@export var lookSpeed : float = 10.0
@export var maxYawAngle : float = PI/2.0
@export var targetTrackPitchRange : Vector2 = Vector2(-PI/12.0, PI/6.0)

@export_category("Animation")
@export var animationSpeedTarget : float = 2.5
@export var directionLerpSpeed : float = 8.0

const moveBlendParam : String = "parameters/MoveDirection/blend_position"
const animationSpeedParam : String = "parameters/TimeScale/scale"

var animationDirection : Vector2 = Vector2()

@onready var stateManager : CharacterStateManager = Util.getChildOfType(get_parent(), CharacterStateManager)

func _ready() -> void:
	assert(stateManager)

func _process(delta: float) -> void:
	var character : Character = stateManager.getCharacter() as Character
	var moveDirection : Vector3 = character.velocity.normalized() * character.global_basis
	var moveDirectionPlanar : Vector2 = Vector2(moveDirection.x, moveDirection.z)

	animationDirection = lerp(animationDirection, moveDirectionPlanar, delta * directionLerpSpeed)

	modelAnimationTree.set(moveBlendParam, animationDirection)
	updateAnimationSpeed(character.velocity.length())

	var controller : Controller = Controller.getController(get_parent())
	var target : Node3D = controller.getTarget()

	if !target:
		aimTowardsForwards(delta)
		return

	var aimDirection : Vector3 = aimPivot.global_position - controller.getTargetPosition()

	var forwardRelative : Vector3 = character.global_basis * Vector3.BACK
	var angleDifference : float = abs(aimDirection.normalized().angle_to(forwardRelative.normalized()))

	if angleDifference > abs(maxYawAngle):
		aimTowardsForwards(delta)
		return

	MathUtil.lerpToVector(aimPivot, Vector3.UP, aimDirection, lookSpeed * delta)
	aimPivot.rotation.x = clampf(aimPivot.rotation.x, -PI/12.0, PI/12.0)

func updateAnimationSpeed(inCharacterSpeed : float) -> void:
	var animationSpeed : float = 1.0

	if inCharacterSpeed > animationSpeedTarget:
		animationSpeed = inCharacterSpeed / animationSpeedTarget

	modelAnimationTree.set(animationSpeedParam, animationSpeed)

func aimTowardsForwards(inDelta : float) -> void:
	aimPivot.set_basis(aimPivot.basis.slerp(Basis.IDENTITY, lookSpeed * inDelta))
