extends Node2D

@onready var player = $"../Player"
@export var goblin: PackedScene

func spawn_gobo():
	if not goblin:
		return

	var entities_node = $".."
	var gobo = goblin.instantiate()
	var radius = $CollisionShape2D.shape.radius
	
	var random_offset = Vector2(
		randf_range(-radius, radius),
		randf_range(-radius, radius)
	)
	
	entities_node.add_child(gobo)
	gobo.player = player
	gobo.global_position = global_position + random_offset
	
	print("Goblin spawned at global cords: ", gobo.global_position)

func _on_timer_timeout() -> void:
	spawn_gobo()
	
