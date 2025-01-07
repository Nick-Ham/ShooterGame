extends RayCast3D
class_name Interactor

const interactionCollisionLayer : int = 32

@onready var controller : Controller = Util.getChildOfType(Character.getOwningCharacter(self), Controller)

var currentInteractable : Interactable = null

func _ready() -> void:
	assert(controller)

	collision_mask = interactionCollisionLayer

	Util.safeConnect(controller.interact_changed, on_interact_changed)

func on_interact_changed(inIsInteracting : bool) -> void:
	if !inIsInteracting and is_instance_valid(currentInteractable):
		currentInteractable.setIsInteracting(false)
		currentInteractable = null
		return

	var interactable : Interactable = getInteractable()
	if !is_instance_valid(interactable):
		return

	currentInteractable = interactable
	currentInteractable.setIsInteracting(true)

func _physics_process(_delta: float) -> void:
	if !is_instance_valid(currentInteractable):
		return

	var interactable : Interactable = getInteractable()
	if interactable != currentInteractable:
		currentInteractable.setIsInteracting(false)
		currentInteractable = null
		return

func getInteractable() -> Interactable:
	if !is_colliding():
		return null

	var collider : Node = get_collider()
	var interactable : Interactable = Util.getChildOfType(collider, Interactable)

	return interactable
