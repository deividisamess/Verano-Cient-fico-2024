class_name DragAndDropComponent
extends Node

@export var actor : CodeBlocks
@export var mouse_detect : Area2D
@export var body_detect : Area2D

var draggable := false
var is_inside_droppable := false
var is_inside_trash := false

var body_ref : Node2D
var offset : Vector2
var initialPos : Vector2

var platform_pos : int:
	set(value):
		platform_pos = value
		pos_changed.emit(actor, value)

signal click_released
signal pos_changed(body: CodeBlocks)

func _ready() -> void:
	mouse_detect.mouse_entered.connect(_on_mouse_detect_mouse_entered)
	mouse_detect.mouse_exited.connect(_on_mouse_detect_mouse_exited)
	body_detect.body_entered.connect(_on_area_2d_body_entered)
	body_detect.body_exited.connect(_on_area_2d_body_exited)

func _process(_delta: float) -> void:
	if !draggable:
		return
	
	if Input.is_action_just_pressed("click"):
		initialPos = actor.global_position
		offset = actor.get_global_mouse_position() - actor.global_position
		Global.is_dragging = true
		
	if Input.is_action_pressed("click"):
		actor.global_position = actor.get_global_mouse_position() - offset
		
	elif Input.is_action_just_released("click"):
		Global.is_dragging = false
		click_released.emit()
		var tween = get_tree().create_tween()
		if(is_inside_trash):
			tween.tween_property(actor, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
			if actor.parent != null: actor.parent.children.erase(actor)
			await tween.finished
			actor.queue_free()
			return
		if !is_inside_droppable:
			tween.tween_property(actor, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
			return
		tween.kill()

func _on_area_2d_body_entered(body):
	if body.is_in_group("droppable"):
		is_inside_droppable = true
		body.modulate = Color(Color.SLATE_GRAY, 0.7)
		platform_pos = body.get_name().to_int()
	
	if body.name == "Trash":
		body.is_in_body = true
		is_inside_trash = true
	
	body_ref = body

func _on_area_2d_body_exited(body):
	if body.is_in_group("droppable"):
		is_inside_droppable = true
		body.modulate = Color(Color.WHITE, 1)
	
	if body.name == "Trash":
		body.is_in_body = false
		is_inside_trash = false

func _on_mouse_detect_mouse_entered():
	if not Global.is_dragging:
		draggable = true
		actor.scale = Vector2(1.47, 1.47)

func _on_mouse_detect_mouse_exited():
	if not Global.is_dragging:
		draggable = false
		actor.scale = Vector2(1.4, 1.4)
