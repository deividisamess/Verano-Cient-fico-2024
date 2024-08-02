extends Node2D

const PLATFORM = preload("res://Prefabs/ui/platform.tscn")

var platforms = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 4:
		create_new_platform()

func create_new_platform():
	var platform = PLATFORM.instantiate()
	add_child(platform)
	platform.name = str(platforms.size())
	platform.position.x = 5
	platform.position.y = platforms.size() * 41.15
	platforms.append(platform)
