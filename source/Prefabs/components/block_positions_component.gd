class_name BlockPositionsComponent
extends Node

@export var blocks : Node2D
@export var block_list : BlockListComponent

func set_blocks_positions():
	for i in blocks.get_child_count() - 3:
		var block = blocks.get_child(i + 3) as CodeBlocks
		block.pos = block.pos

func replace_position(pos1, pos2):
	block_list.block_array[pos2].pos = pos1
	block_list.block_array[pos1].pos = pos2

func on_changed_position(dragging_block : CodeBlocks, new_pos : int):
	if dragging_block.pos == new_pos:
		return
	if dragging_block.override:
		return
	
	block_list.fill_block_array()
	var fromTop := new_pos - dragging_block.pos > 0
	
	var target_block
	
	if dragging_block.type == CodeBlocks.TYPE_BLOCK.MOVE:
		target_block = block_list.get_block(new_pos)
		if target_block == null:
				return
		if fromTop:
			if new_pos == target_block.pos:
				if target_block.size > 1:
					dragging_block.indented = true
					target_block.children.append(dragging_block)
					dragging_block.parent = target_block
					if !block_list.is_function_empty(new_pos):
						target_block.increase_size()
				replace_position(dragging_block.pos, target_block.pos)
			
			if new_pos == target_block.pos + target_block.size - 1 && target_block.size > 3:
				target_block.decrease_size()
				dragging_block.indented = false
				target_block.children.erase(dragging_block)
				dragging_block.parent = null
				dragging_block.pos = new_pos
		else:
			if new_pos == target_block.pos:
				if target_block.size > 1:
					if target_block.size != 3:
						target_block.decrease_size()
					dragging_block.indented = false
					target_block.children.erase(dragging_block)
					dragging_block.parent = null
				replace_position(dragging_block.pos, target_block.pos)
			
			if new_pos == target_block.pos + target_block.size - 1:
				if target_block.size > 1 && !block_list.is_function_empty(target_block.pos):
					target_block.increase_size()
					dragging_block.indented = true
					target_block.children.append(dragging_block)
					dragging_block.parent = target_block
					dragging_block.pos = new_pos
	else:
		var delta_pos = dragging_block.pos
		
		var delta_target_pos
		if fromTop:
			target_block = block_list.get_block(new_pos + dragging_block.size - 1)
			if target_block == null:
				return
			delta_target_pos = target_block.pos
			target_block.override = true
			target_block.pos = dragging_block.pos
		else:
			target_block = block_list.get_block(dragging_block.pos - 1)
			delta_target_pos = target_block.pos
			target_block.override = true
			target_block.pos = dragging_block.pos + dragging_block.size - target_block.size
		if target_block.type != CodeBlocks.TYPE_BLOCK.MOVE:
			delta_target_pos = target_block.pos - delta_target_pos
			for i in target_block.children.size():
				target_block.children[i].pos += delta_target_pos
		dragging_block.override = true
		dragging_block.pos = 30 - dragging_block.size
		delta_pos = dragging_block.pos - delta_pos
		for i in dragging_block.children.size():
			dragging_block.children[i].pos += delta_pos
		delta_pos = dragging_block.pos
		dragging_block.pos = block_list.free_slot_outside_function()
		delta_pos = dragging_block.pos - delta_pos
		for i in dragging_block.children.size():
			dragging_block.children[i].pos += delta_pos
		await get_tree().create_timer(0.2).timeout
		target_block.override = false
		dragging_block.override = false

func on_click_released():
	set_blocks_positions()
