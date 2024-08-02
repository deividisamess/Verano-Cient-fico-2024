class_name Goal
extends Area2D

@export_file var next_level
@onready var game_manager: GameManager = %GameManager

signal goal_reached

func _on_body_entered(body):
	body.goal_reached = true
	goal_reached.emit()
