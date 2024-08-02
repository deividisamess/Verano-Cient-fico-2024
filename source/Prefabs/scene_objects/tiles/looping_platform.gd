class_name LoopingPlatform
extends Area2D

@onready var label: Label = $Label
@export var expected_moves : String

signal reached_zero
var delta = 1

func _ready() -> void:
	label.text = expected_moves

func _on_body_exited(_body: Node2D) -> void:
	label.text = str(int(label.text) - delta)
	if int(label.text) == 0:
		reached_zero.emit()
		delta = 0
