extends Node2D


@export var rotation_speed: float = 15.0

func _process(delta: float) -> void:
	var target_vector = get_global_mouse_position() - global_position
	
	var target_angle = target_vector.angle()
	
	global_rotation = rotate_toward(global_rotation, target_angle, rotation_speed * delta)
	



func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
	
