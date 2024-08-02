class_name CodeBlocks
extends Node2D
# Tile Maps
@onready var overlay = $Overlay
@onready var sombra = $Sombra

var override := false
var pos: int:
	set(value):
		pos = value
		if is_inside_tree():
			var tween = get_tree().create_tween()
			tween.tween_property(self, "position", Vector2([5, 46.25][int(indented)], pos * 41.15), 0.2)
		else:
			position.y = pos * 41.15
var indented := false:
	set(value):
		indented = value
		position.x = [5, 46.25][int(indented)]

enum TYPE_BLOCK {MOVE, IF, REPEAT}
@export var size : int
@export var type : TYPE_BLOCK
