class_name IfBlocks extends FunctionBlocks

static var TILES = {0: "crash_tile", 1: "up_tile", 2: "down_tile"}

@onready var tile = $Overlay/Control/TileSelect/tile
var tile_value : int:
	get:
		return tile.selected

@onready var behaviour = $Overlay/Control/BehaviourSelect/behaviour
var behaviour_value : String:
	get:
		return behaviour.text
