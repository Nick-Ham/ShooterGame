extends Node
class_name LevelSpawnManager

@export_category("Config")
@export var enabled : bool = true
@export var minSpawnTime : float = 5.0
@export var maxSpawnTime : float = 10.0
@export var spawnChoices : Array[PackedScene]

@export_category("Ref")
@export var spawnTimer : Timer = null

var spawnPads : Array[SpawnPad] = []

func _ready() -> void:
	assert(spawnTimer)
	assert(spawnChoices.size() > 0)

	spawnTimer.one_shot = true
	call_deferred("handleTimer")

	Util.safeConnect(spawnTimer.timeout, on_spawnTimer_timeout)

func getSpawnAmount() -> int:
	return 1

func handleTimer() -> void:
	if enabled:
		for i : int in range(getSpawnAmount()):
			var nextPad : SpawnPad = spawnPads.pick_random() as SpawnPad
			nextPad.spawnObject(spawnChoices.pick_random())

	spawnTimer.start(randf_range(minSpawnTime, maxSpawnTime))

func on_spawnTimer_timeout() -> void:
	handleTimer()

func registerSpawnPad(inPad : SpawnPad) -> void:
	spawnPads.append(inPad)
