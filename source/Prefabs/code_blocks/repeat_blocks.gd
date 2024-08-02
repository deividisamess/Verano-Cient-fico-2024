extends FunctionBlocks

@onready var iterations: OptionButton = $Overlay/Control/RepeatControl/iterations
var iterations_value : int :
	get:
		return int(iterations.text)
