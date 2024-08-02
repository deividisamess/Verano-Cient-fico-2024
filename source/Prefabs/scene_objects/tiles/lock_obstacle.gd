extends StaticBody2D

@export var loop_platform : LoopingPlatform

func _ready() -> void:
	loop_platform.reached_zero.connect(queue_free)
