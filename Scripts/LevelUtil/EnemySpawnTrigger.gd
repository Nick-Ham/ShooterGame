extends Area3D
class_name EnemySpawnTrigger

@export_category("Ref")
@export var spawnMarkers : Array[SpawnMarker]

const playerCollisionMaskBit : int = 2

func _ready() -> void:
	collision_layer = 0
	collision_mask = playerCollisionMaskBit

	body_entered.connect(on_body_entered)

func on_body_entered(_inBody : PhysicsBody3D) -> void:
	var level : Level = Game.getGame(get_tree()).getLevel()
	if !level.getSpawnTriggersEnabled():
		return

	for spawnMarker : SpawnMarker in spawnMarkers:
		if !spawnMarker:
			continue

		spawnMarker.spawn()

	queue_free()
