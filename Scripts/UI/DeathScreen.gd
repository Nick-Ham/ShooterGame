extends MenuBase
class_name DeathScreen

@export_category("Ref")
@export var menuBkg : Panel
@export var animationPlayer : AnimationPlayer
@export var resetLevelButton : Button
@export var quitButton : Button

@export_category("Anim")
@export var bkgAlpha : float = 0.0:
	set(inNewAlpha):
		bkgAlpha = inNewAlpha
		updateMaterialProperty(bkgAlphaParameter, bkgAlpha)

const fadeInAnimationKey : String = "DeathScreenFadeIn"

const bkgAlphaParameter : String = "AlphaParam"

func _ready() -> void:
	assert(menuBkg)
	assert(animationPlayer)
	assert(resetLevelButton)
	assert(quitButton)

	animationPlayer.play(fadeInAnimationKey)
	Util.safeConnect(resetLevelButton.pressed, on_resetLevelButton_pressed)
	Util.safeConnect(quitButton.pressed, on_quitButton_pressed)

func on_quitButton_pressed() -> void:
	get_tree().quit()

func on_resetLevelButton_pressed() -> void:
	Game.getGame(get_tree()).resetCurrentLevel()

func updateMaterialProperty(inPropertyName : String, inPropertyValue : float) -> void:
	menuBkg.material.set_shader_parameter(inPropertyName, inPropertyValue)
