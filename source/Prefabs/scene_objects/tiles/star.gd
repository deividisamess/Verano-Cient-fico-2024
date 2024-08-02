extends Area2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var game_manager: GameManager = %GameManager
@onready var sprite_2d: Sprite2D = $Sprite2D
var collected = false

func _on_body_entered(_body: Node2D) -> void:
	game_manager.stars_collected += 1
	sprite_2d.visible = false
	cpu_particles_2d.emitting = true
	await cpu_particles_2d.finished
	queue_free()
