extends Panel

@onready var blocks = $ScrollBlocks/Control/BlockContainer/Blocks
@onready var platforms = $ScrollBlocks/Control/PlatformContainer/Platforms
@onready var control = $ScrollBlocks/Control
var player: CharacterBody2D
signal pausePressed

func _on_play_pressed():
	blocks.get_node("BlockListComponent").fill_block_array()
	
	for i in blocks.get_child_count() - 3:
		var block = blocks.get_child(i + 3) as CodeBlocks
		if block == null:
			return
		match block.type:
			CodeBlocks.TYPE_BLOCK.MOVE:
				var text_block = block.direction_value
				var number_moves = block.moves_value
				var in_function = false
				if block.parent != null:
					in_function = true
				
				if text_block.ends_with("Up"):
					for j in number_moves:
						player.move(player.UP, in_function)
				elif text_block.ends_with("Down"):
					for j in number_moves:
						player.move(player.DOWN, in_function)
				elif text_block.ends_with("Right"):
					for j in number_moves:
						player.move(player.RIGHT, in_function)
				elif text_block.ends_with("Left"):
					for j in number_moves:
						player.move(player.LEFT, in_function)
			CodeBlocks.TYPE_BLOCK.IF:
				var tile_selected = block.tile_value
				var behaviour = block.behaviour_value
				player.check_condition(tile_selected, behaviour)
			CodeBlocks.TYPE_BLOCK.REPEAT:
				var iterations_value = block.iterations_value
				player.iterate_functions(iterations_value)
		
		

func _on_move_robot_pressed():
	blocks.get_node("BlockSpawnerComponent").create_new_block(CodeBlocks.TYPE_BLOCK.MOVE)
	can_create_new_platform()

func _on_if_else_pressed():
	blocks.get_node("BlockSpawnerComponent").create_new_block(CodeBlocks.TYPE_BLOCK.IF)
	can_create_new_platform()
	can_create_new_platform()
	can_create_new_platform()

func _on_repeat_pressed():
	blocks.get_node("BlockSpawnerComponent").create_new_block(CodeBlocks.TYPE_BLOCK.REPEAT)
	can_create_new_platform()
	can_create_new_platform()
	can_create_new_platform()

func can_create_new_platform():
	if blocks.get_node("BlockListComponent").count > 3:
		platforms.create_new_platform()
		control.custom_minimum_size.y += 41.15

func _on_pause_button_pressed():
	pausePressed.emit()
