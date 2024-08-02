extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(Color.WHITE, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	if Global.is_dragging:
		visible = true
	else:
		visible = false
