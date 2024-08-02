extends Node

@onready var animation_player = $SceneObjects/AnimationPlayer

func _on_player_player_stepping_into(_dir):
	animation_player.stop(true)
