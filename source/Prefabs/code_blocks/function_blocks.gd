class_name FunctionBlocks
extends CodeBlocks

var children : Array[MoveBlocks] = []
var last_frame_pos : Vector2
var flag = false

func _process(_delta: float) -> void:
	if last_frame_pos != position:
		flag = true
		for i in children.size():
			children[i].override = true
			children[i].position += position - last_frame_pos
	elif flag:
		for i in children.size():
			children[i].override = false
		flag = false
	last_frame_pos = position

func increase_size():
	var new_row = [Vector2i(1, 1), Vector2i(2, 2), Vector2i(2, 2), Vector2i(2, 2),
					Vector2i(3, 1), Vector2i(2, 2), Vector2i(2, 2), Vector2i(2, 2),
					Vector2i(0, 2), Vector2i(1, 2), Vector2i(1, 0), Vector2i(2, 0), 
					Vector2i(0, 1), Vector2i(2, 2), Vector2i(2, 2), Vector2i(2, 2)]
	var c = 0
	for y in 4:
		for x in 4:
			overlay.set_cell(0, Vector2i(x, size + y - 2), 0, new_row[c])
			sombra.set_cell(0, Vector2i(x, size + y - 2), 0, new_row[c])
			c += 1
	size += 1

func decrease_size():
	var new_row = [Vector2i(3, 1), Vector2i(2, 2), Vector2i(2, 2), Vector2i(2, 2),
					Vector2i(0, 2), Vector2i(1, 2), Vector2i(1, 0), Vector2i(2, 0), 
					Vector2i(0, 1), Vector2i(2, 2), Vector2i(2, 2), Vector2i(2, 2)]
	for y in 2:
		for x in 4:
			overlay.erase_cell(0, Vector2i(x, y + size - 1))
			sombra.erase_cell(0, Vector2i(x, y + size - 1))
	var c = 0
	for y in 3:
		for x in 4:
			overlay.set_cell(0, Vector2i(x, y + size - 3), 0, new_row[c])
			sombra.set_cell(0, Vector2i(x, y + size - 3), 0, new_row[c])
			c += 1
	size -= 1
