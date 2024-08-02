extends StaticBody2D

@onready var texture_rect = $TextureRect

var is_in_body = false

func _process(_delta):
	if Global.is_dragging && !is_in_body:
		texture_rect.modulate = Color.RED
	elif is_in_body:
		texture_rect.modulate = Color.YELLOW
	else:
		texture_rect.modulate = Color.BLACK
