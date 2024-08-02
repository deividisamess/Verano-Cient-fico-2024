class_name BlockListComponent
extends Node

@export var blocks : Node2D
@onready var platforms : Node2D = blocks.platforms

var block_array : Array[CodeBlocks] = []
var count := 0

func get_block(pos : int):
	return block_array[pos]

func get_function_block(pos : int):
	var i := 0
	if !is_inside_function(pos):
		return null
	while is_inside_function(pos - i):
		i += 1
	return block_array[pos - i]

func fill_block_array():
	block_array.resize(30)
	block_array.fill(null)
	for i in blocks.get_child_count() - 3:
		var block = blocks.get_child(i + 3)
		block_array[block.pos] = block
		if(block.size > 1):
			block_array[block.pos + block.size - 1] = block

func is_function_empty(pos):
	fill_block_array()
	if block_array[pos].size == 3:
		return block_array[pos + 1] == null
	return false

func is_inside_function(pos: int):
	fill_block_array()
	var block_reference = block_array[pos - 1]
	if block_reference == null:
		return false
	
	if block_reference.size != 1:
		if (block_reference.pos == pos - 1):
			return block_reference == block_array[pos + block_reference.size - 2]
		else:
			return false
	else:
		return is_inside_function(block_reference.pos)

func is_platform_free(pos : int):
	fill_block_array()
	return block_array[pos] == null

func free_slot():
	fill_block_array()
	for i in block_array.size():
		if block_array[i] == null:
			return i

func free_slot_outside_function():
	fill_block_array()
	for i in block_array.size():
		if block_array[i] == null && !is_inside_function(i):
			return i
