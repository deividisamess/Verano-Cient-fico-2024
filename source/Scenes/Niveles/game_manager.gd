class_name GameManager
extends Node

var stars_collected := 0
@export var stars: Node
var max_stars : int = 0

func _ready() -> void:
	if stars != null:
		max_stars = stars.get_child_count()
