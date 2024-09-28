extends CenterContainer
class_name Reticle

@export_category("Config")
@export var centerDotSize : float = 1.0
@export var reticleSize : float = 25.0
@export var reticleWidth : float = 0.5
@export var reticleColor : Color = Color.GRAY

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2(), centerDotSize, reticleColor)
	draw_circle(Vector2(), reticleSize, reticleColor, false, reticleWidth, true)
