extends Node
class_name ScreenEffectController

@export_category("Config")
@export var fadeSpeed : float = 0.9
@export var armorIncreasedEffectColor : Color = Color("4fafff9b")
@export var healthIncreasedEffectColor : Color = Color("00ba0d9b")
@export var otherEffectColor : Color = Color("ffffff64")
@export_group("FadeModifier")
@export var otherEffectFadeModifier : float = 0.5

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var itemManager : ItemManager = Util.getChildOfType(owningCharacter, ItemManager)

var armorScreenEffectID : int = -1
var healthScreenEffectID : int = -1
var otherScreenEffectID : int = -1

func _ready() -> void:
	assert(owningCharacter)
	assert(itemManager)

	Util.safeConnect(itemManager.item_added, on_item_added)

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

	otherScreenEffectID = ScreenEffects.AddScreenFade(fadeSpeed, otherEffectColor)

func addArmorEffect() -> void:
	if armorScreenEffectID != -1:
		var screenFade : cScreenFade = ScreenEffects.GetScreenFadeInstanceById(armorScreenEffectID)
		if is_instance_valid(screenFade):
			screenFade.Stop()
			armorScreenEffectID = -1

	armorScreenEffectID = ScreenEffects.AddScreenFade(fadeSpeed, armorIncreasedEffectColor)

func addHealthEffect() -> void:
	if healthScreenEffectID != -1:
		var screenFade : cScreenFade = ScreenEffects.GetScreenFadeInstanceById(armorScreenEffectID)
		if is_instance_valid(screenFade):
			screenFade.Stop()
			healthScreenEffectID = -1

	healthScreenEffectID = ScreenEffects.AddScreenFade(fadeSpeed * otherEffectFadeModifier, healthIncreasedEffectColor)
