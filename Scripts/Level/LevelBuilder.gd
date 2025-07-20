extends Node
class_name LevelBuilder

@onready var fillerPiecePacked : PackedScene = preload("res://Scenes/MapPieces/FillerMapPiece.tscn")
@onready var escapeDoorPiecePacked : PackedScene = preload("res://Scenes/MapPieces/EscapeDoorPiece.tscn")

var mapPieceMarkers : Array[MapPieceMarker] = []
var mapPieces : Array[MapPiece]

var escapeDoor : MapPiece

func registerDoorPieceMarker(inMarker : MapPieceMarker) -> void:
	mapPieceMarkers.append(inMarker)

func buildMap() -> void:
	if mapPieceMarkers.size() < 2:
		push_error("Must have at least 2 map pieces to build.")
		return

	setupMapPieces()

func setupMapPieces() -> void:
	var level : Level = Game.getGame(get_tree()).getLevel()

	var remainingMarkers : Array[MapPieceMarker] = mapPieceMarkers.duplicate()
	setupEscapeDoor(remainingMarkers)

	for marker : MapPieceMarker in remainingMarkers:
		var newMapPiece : Node3D = fillerPiecePacked.instantiate() as MapPiece
		level.add_child(newMapPiece)
		mapPieces.append(newMapPiece)

		newMapPiece.global_position = marker.global_position
		newMapPiece.setDirection(marker.getDirection())

func setupEscapeDoor(inMarkers : Array[MapPieceMarker]) -> void:
	var randomMarker : MapPieceMarker = inMarkers.pick_random()
	inMarkers.erase(randomMarker)

	var newMapPiece : Node3D = escapeDoorPiecePacked.instantiate() as MapPiece

	var level : Level = Game.getGame(get_tree()).getLevel()
	level.add_child(newMapPiece)

	newMapPiece.global_position = randomMarker.global_position
	newMapPiece.setDirection(randomMarker.getDirection())

	mapPieces.append(newMapPiece)
	escapeDoor = newMapPiece
