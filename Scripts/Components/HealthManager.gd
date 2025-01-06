extends Node
class_name CharacterHealthManager

@export_category("Ref")
@export var health : Health
@export var characterStateManager : CharacterStateManager

@onready var character : Character = Character.getOwningCharacter(self)

const destroyedKey : String = "destroyed"

func _ready() -> void:
	assert(health)
	assert(characterStateManager)
	assert(character)

	Util.safeConnect(health.health_depleted, on_health_depleted)

func on_health_depleted(_inHealth : Health) -> void:
	characterStateManager.forceChangeState(destroyedKey)
	character.destroyCharacter()

	health.queue_free()
	var overshieldHealth : OvershieldHealth = Util.getChildOfType(character, OvershieldHealth)
	if overshieldHealth:
		overshieldHealth.queue_free()

	var controller : Controller = Util.getChildOfType(character, Controller)
	if is_instance_valid(controller):
		controller.queue_free()
