extends Node

@onready var settings_button: Button = $SettingsButton
@export var button_expand_icon : Texture2D
@export var button_contract_icon : Texture2D

func _on_nivel_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/Niveles/nivel_1.tscn")

func _on_nivel_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		settings_button.icon = button_contract_icon
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		settings_button.icon = button_expand_icon
