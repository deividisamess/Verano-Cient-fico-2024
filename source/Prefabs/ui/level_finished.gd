extends Node

var goal : Goal
@onready var level_finished_panel: Panel = $LevelFinishedPanel
@onready var game_manager = get_parent().get_node("%GameManager")

@onready var stars_container: HBoxContainer = $LevelFinishedPanel/Panel/StarsContainer

@onready var button_container = $LevelFinishedPanel/Panel/ButtonContainer

func set_goal(importedGoal : Goal):
	goal = importedGoal
	goal.goal_reached.connect(on_level_finished)

func on_level_finished():
	if game_manager.max_stars == 0:
		button_container.size = Vector2(312, 70)
		button_container.position = Vector2(13, 168)
		button_container.scale = Vector2(1.5, 1.5)
	else:
		for i in game_manager.max_stars:
			stars_container.get_child(i).show()
		
		for i in game_manager.max_stars - game_manager.stars_collected:
			var star = stars_container.get_child(game_manager.max_stars - 1 - i) as TextureRect
			star.modulate = Color.html("695900")
	
	level_finished_panel.show()

func _on_next_level_button_pressed() -> void:
	get_tree().change_scene_to_file(goal.next_level)

func _on_menu_button_pressed() -> void:
	Global.is_dragging = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_reset_level_button_pressed():
	get_tree().reload_current_scene()
