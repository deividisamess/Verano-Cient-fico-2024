class_name BlockSpawnerComponent
extends Node

@export var MOVE_BLOCKS : PackedScene
@export var IF_BLOCKS : PackedScene
@export var REPEAT_BLOCKS : PackedScene

@export var block_list : BlockListComponent
@export var block_positions : BlockPositionsComponent

func create_new_block(type : CodeBlocks.TYPE_BLOCK) -> void:
	var block : CodeBlocks = null
	
	match type:
		CodeBlocks.TYPE_BLOCK.MOVE:
			block = MOVE_BLOCKS.instantiate()
			block.indented = block_list.is_inside_function(block_list.free_slot())
			block.pos = block_list.free_slot()
			block_list.count += 1
		CodeBlocks.TYPE_BLOCK.IF:
			block = IF_BLOCKS.instantiate()
			block_list.count += 3
		CodeBlocks.TYPE_BLOCK.REPEAT:
			block = REPEAT_BLOCKS.instantiate()
			block_list.count += 3
		_:
			return
	
	var drag : DragAndDropComponent = block.get_node("DragAndDropComponent")
	drag.click_released.connect(block_positions.on_click_released)
	drag.pos_changed.connect(block_positions.on_changed_position)
	block.set_name(str(block_list.count))
	
	if block.size != 1: 
		block.pos = block_list.free_slot_outside_function()
		block.indented = false
	
	get_parent().add_child(block)
	if block.indented:
		block_list.get_function_block(block.pos).children.append(block)
		block.parent = block_list.get_function_block(block.pos)
