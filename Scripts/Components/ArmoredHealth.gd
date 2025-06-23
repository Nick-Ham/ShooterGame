extends Health
class_name ArmoredHealth

static var armorItem : QuantityItem = load("res://Data/QuantityItem/ArmorItem.tres")
static var healthItem : QuantityItem = load("res://Data/QuantityItem/HealthItem.tres")

@export_group("Cheat")
@export var immortal : bool = false

@export_category("Config")
@export var maxArmor : float = 100.0
@export_group("Default")
@export var useCustomArmor : bool = false
@export var customArmor : float = 100.0

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var itemManager : ItemManager = Util.getChildOfType(owningCharacter, ItemManager)

var currentArmor : float = 1.0

signal armor_depleted
signal armor_changed(inPreviousArmor : float, inNewArmor : float)

const armorDamageAbsorption : float = .66 # 0 -> 1.0

func _enter_tree() -> void:
	super._enter_tree()

	currentArmor = maxArmor

	if useCustomArmor:
		currentArmor = customArmor

func _ready() -> void:
	assert(owningCharacter, "ArmoredHealth only usable on Character")

	if itemManager:
		Util.safeConnect(itemManager.item_added, on_item_added)

func on_item_added(inNewItem : Item) -> void:
	var quantityItem : QuantityItem = inNewItem as QuantityItem

	if !is_instance_valid(quantityItem):
		return

	if quantityItem == armorItem:
		addArmor(quantityItem.quantity)
	elif quantityItem == healthItem:
		restoreHealth(quantityItem.quantity)

	itemManager.consumeItem(inNewItem)

func getMaxArmor() -> float:
	return maxArmor

func getCurrentArmor() -> float:
	return currentArmor

func getArmorDepleted() -> bool:
	return is_zero_approx(currentArmor)

func addArmor(inArmor : float) -> void:
	var previousArmor : float = currentArmor
	currentArmor = clampf(currentArmor + inArmor, 0.0, maxArmor)
	armor_changed.emit(previousArmor, currentArmor)

func takeDamage(inDamage : float) -> void:
	if immortal:
		return

	if getArmorDepleted():
		super.takeDamage(inDamage)

	var startingArmor : float = currentArmor
	var startingHealth : float = currentHealth

	var damageToArmor : float = inDamage * armorDamageAbsorption
	var damageToHealth : float = inDamage * (1.0 - armorDamageAbsorption)

	currentArmor -= damageToArmor
	if currentArmor < 0.0:
		damageToHealth += abs(currentArmor)
		currentArmor = 0.0

	currentHealth -= damageToHealth

	if !is_equal_approx(startingArmor, currentArmor):
		armor_changed.emit(startingArmor, currentArmor)

	if !is_equal_approx(startingHealth, currentHealth):
		health_changed.emit(startingHealth, currentHealth)

	if !startingArmor <= 0 and currentArmor <= 0:
		armor_depleted.emit()

	if !startingHealth <= 0 and currentHealth <= 0:
		health_depleted.emit(self)
