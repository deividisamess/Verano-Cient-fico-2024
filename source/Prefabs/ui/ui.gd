extends CanvasLayer

@export var player : CharacterBody2D
@export var label_text = ""
@export_enum("Move", "If", "Repeat") var type_ui: int
@export var goal : Goal

@onready var pause = $Pause
@onready var label = $"UI Controls/Label"
@onready var level_finished: Node = $LevelFinished

@onready var if___else = $"UI Controls/Buttons/HBoxContainer/If - Else"
@onready var repeat = $"UI Controls/Buttons/HBoxContainer/Repeat"
@onready var ui_controls: Panel = $"UI Controls"

func _ready():
	label.text = label_text
	match type_ui:
		0:
			if___else.queue_free()
			repeat.queue_free()
		1:
			repeat.queue_free()
	ui_controls.player = player
	level_finished.set_goal(goal)

func _on_ui_controls_pause_pressed():
	pause.pause()
