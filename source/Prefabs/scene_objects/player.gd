extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var death = $Death
@onready var ray_cast_2d : RayCast2D = $RayCast2D
@onready var area_2d = $Area2D

const SPEED = 18000
const UP : Vector2 = Vector2(0, -1)
const DOWN : Vector2 = Vector2(0, 1)
const RIGHT : Vector2 = Vector2(1, 0)
const LEFT : Vector2 = Vector2(-1, 0)
const IDLE = false
const MOVING = true

var direction : Vector2 = Vector2()
var pos : Vector2 = Vector2()
var inputBuffer : Array[Callable] = []
var in_function_array : Array[bool]
var died = false
var goal_reached = false
var last_frame_collider : Object = null
var is_performing_action = false
var has_moved = false
var func_selected : Dictionary = {"Wait": wait_collision_stop, "Step Into": wait_collision_selected}

signal player_stepping_into(dir : Vector2)
signal raycast_stopped_hitting
signal raycast_kept_hitting
signal action_finished

func perform_next_action():
	idle()
	is_performing_action = false
	if(!inputBuffer.is_empty()):
		var next_action = inputBuffer.pop_front()
		in_function_array.pop_front()
		next_action.call()
	elif inputBuffer.is_empty() and has_moved and !goal_reached:
		die()

func idle():
	velocity = Vector2()
	if velocity == Vector2():
		match direction:
			UP:
				animated_sprite_2d.animation = "idle_top"
			DOWN:
				animated_sprite_2d.animation = "idle_down"
			LEFT:
				animated_sprite_2d.animation = "idle_side"
				animated_sprite_2d.flip_h = true
			RIGHT:
				animated_sprite_2d.animation = "idle_side"
				animated_sprite_2d.flip_h = false

func move(dir : Vector2, in_function := false):
	has_moved = true
	if(!is_performing_action && !died):
		direction = dir
		match direction:
			UP:
				direction = Vector2(0, -1)
				animated_sprite_2d.animation = "walk_top"
				ray_cast_2d.target_position = Vector2.UP * 50
			DOWN:
				direction = Vector2(0, 1)
				animated_sprite_2d.animation = "walk_down"
				ray_cast_2d.target_position = Vector2.DOWN * 50
			LEFT:
				direction = Vector2(-1, 0)
				animated_sprite_2d.animation = "walk_side"
				animated_sprite_2d.flip_h = true
				ray_cast_2d.target_position = Vector2.LEFT * 50
			RIGHT:
				direction = Vector2(1, 0)
				animated_sprite_2d.animation = "walk_side"
				animated_sprite_2d.flip_h = false
				ray_cast_2d.target_position = Vector2.RIGHT * 50
		is_performing_action = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + Vector2(80, 80) * direction, 0.25)
		await tween.finished
		action_finished.emit()
	else:
		inputBuffer.push_back(move.bind(dir, in_function))
		in_function_array.push_back(in_function)

func check_condition(tile_selected : int, true_behaviour : String):
	if is_performing_action or died:
		inputBuffer.push_back(check_condition.bind(tile_selected, true_behaviour))
		in_function_array.push_back(false)
		return
	
	is_performing_action = true
	
	# Wait 2 Seconds for collisions
	var i := 0.0
	while !ray_cast_2d.is_colliding() && i < 2:
		i += 0.5
		await get_tree().create_timer(0.2).timeout
	
	if !ray_cast_2d.is_colliding():
		while in_function_array[0]:
			inputBuffer.remove_at(0)
			in_function_array.remove_at(0)
			if in_function_array.is_empty():
				break
		action_finished.emit()
		return
	
	# False State
	if !ray_cast_2d.get_collider().is_in_group(IfBlocks.TILES[tile_selected]):
		i = 0
		while in_function_array[0]:
			inputBuffer.remove_at(0)
			in_function_array.remove_at(0)
			if in_function_array.is_empty():
				break
		action_finished.emit()
		return
	
	# True State
	func_selected[true_behaviour].call()

func iterate_functions(iterations_value : int):
	if is_performing_action or died:
		inputBuffer.push_back(iterate_functions.bind(iterations_value))
		in_function_array.push_back(false)
		return
	
	is_performing_action = true
	await get_tree().create_timer(0.2).timeout
	
	var children : int = 0
	var index := 0
	while in_function_array.size() > index:
		if in_function_array[index]:
			children += 1
		else:
			break
		index += 1

	for i in iterations_value:
		for j in children:
			inputBuffer[j].call()
	
	for i in children:
		inputBuffer.pop_front()
		in_function_array.pop_front()
	
	for i in inputBuffer.size() - children * iterations_value:
		inputBuffer.push_back(inputBuffer.pop_front())
		in_function_array.push_back(in_function_array.pop_front())
	
	action_finished.emit()

func _physics_process(_delta):
	if ray_cast_2d.get_collider() != last_frame_collider and last_frame_collider != null:
		raycast_stopped_hitting.emit()
	else:
		raycast_kept_hitting.emit()
	last_frame_collider = ray_cast_2d.get_collider()

func _on_area_2d_body_entered(body):
	if(body.is_in_group("crash")):
		die()

func die():
	death.animation = "die"
	animated_sprite_2d.visible = false
	died = true
	velocity = Vector2.ZERO
	await death.animation_finished
	if get_tree():
		get_tree().reload_current_scene()

func wait_collision_stop():
	await raycast_stopped_hitting
	action_finished.emit()

func wait_collision_selected():
	await raycast_kept_hitting
	player_stepping_into.emit(direction)
	inputBuffer.push_front(move.bind(direction))
	in_function_array.push_front(false)
	action_finished.emit()
