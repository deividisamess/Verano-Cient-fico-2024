extends Node

@onready var pause_panel = $PausePanel

func _process(_delta):
	var esc_pressed = Input.is_action_just_pressed("pause")
	if esc_pressed:
		pause()

func _on_resume_button_pressed():
	pause_panel.hide()
	get_tree().paused = false

func _on_menu_button_pressed():
	Global.is_dragging = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func pause():
	get_tree().paused = true
	pause_panel.show()
