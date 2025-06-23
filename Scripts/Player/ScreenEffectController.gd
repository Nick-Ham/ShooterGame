extends Node
class_name ScreenEffectController

@export_category("Config")
@export var fadeSpeed : float = 0.9
@export var armorIncreasedEffectColor : Color = Color("4fafff9b")
@export var healthIncreasedEffectColor : Color = Color("00ba0d9b")
@export var otherEffectColor : Color = Color("ffffff64")
@export var damageEffectColor : Color = Color("ff584b2b")
@export_group("FadeModifier")
@export var otherEffectFadeModifier : float = 0.5

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var itemManager : ItemManager = Util.getChildOfType(owningCharacter, ItemManager)
@onready var health : Health = Util.getChildOfType(owningCharacter, Health)

var armorScreenEffectID : int = -1
var healthScreenEffectID : int = -1
var damageScreenEffectID : int = -1
var otherScreenEffectID : int = -1

func _ready() -> void:
	assert(owningCharacter)
	assert(itemManager)
	assert(health)

	Util.safeConnect(itemManager.item_added, on_item_added)
	Util.safeConnect(health.health_changed, on_health_changed)

	setupEffectDefaults()

func setupEffectDefaults() -> void:

	ScreenEffects.mbMotionBlurActive = false

	return

func on_health_changed(inPreviousHealth : float, inNewHealth : float) -> void:
	if inPreviousHealth < inNewHealth:
		return

	addDamageEffect()

func on_item_added(inItem : Item) -> void:
	if inItem == ArmoredHealth.armorItem:
		addArmorEffect()
		return
	elif inItem == ArmoredHealth.healthItem:
		addHealthEffect()
		return
	elif is_instance_of(inItem, QuantityItem):
		addOtherEffect()
		return

func addOtherEffect() -> void:
	if otherScreenEffectID != -1:
		var screenFade : cScreenFade = ScreenEffects.GetScreenFadeInstanceById(otherScreenEffectID)
		if is_instance_valid(screenFade):
			screenFade.Stop()
			otherScreenEffectID = -1

	otherScreenEffectID = ScreenEffects.AddScreenFade(fadeSpeed * otherEffectFadeModifier, otherEffectColor)

func addArmorEffect() -> void:
	if armorScreenEffectID != -1:
		var screenFade : cScreenFade = ScreenEffects.GetScreenFadeInstanceById(armorScreenEffectID)
		if is_instance_valid(screenFade):
			screenFade.Stop()
			armorScreenEffectID = -1

	armorScreenEffectID = ScreenEffects.AddScreenFade(fadeSpeed, armorIncreasedEffectColor)

func addHealthEffect() -> void:
	if healthScreenEffectID != -1:
		var screenFade : cScreenFade = ScreenEffects.GetScreenFadeInstanceById(healthScreenEffectID)
		if is_instance_valid(screenFade):
			screenFade.Stop()
			healthScreenEffectID = -1

	healthScreenEffectID = ScreenEffects.AddScreenFade(fadeSpeed, healthIncreasedEffectColor)

func addDamageEffect() -> void:
	if damageScreenEffectID != -1:
		var screenFade : cScreenFade = ScreenEffects.GetScreenFadeInstanceById(damageScreenEffectID)
		if is_instance_valid(screenFade):
			screenFade.Stop()
			damageScreenEffectID = -1

	damageScreenEffectID = ScreenEffects.AddScreenFade(fadeSpeed, damageEffectColor)
