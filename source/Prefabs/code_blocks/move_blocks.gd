class_name MoveBlocks
extends CodeBlocks

var parent : FunctionBlocks

@onready var moves: OptionButton = $Overlay/Control/MovesControl/moves
var moves_value : int:
	get:
		return int(moves.text)

@onready var direction: OptionButton = $Overlay/Control/DirectionControl/direction
var direction_value : String:
	get:
		return direction.text
