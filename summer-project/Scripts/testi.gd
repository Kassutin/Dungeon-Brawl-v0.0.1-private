extends CharacterBody2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

@export var speed: float = 50.0
@export var player: Node2D # Assign your Player node in the Inspector

@export var health = 2
var stop_update = false

func die():
	var sprite = $AnimatedSprite2D 
	sprite.play("Death")
	stop_update = true
	await $AnimatedSprite2D.animation_finished
	stop_update = false
	

func take_damage():
	health =- 1
	print("ouch")
	var sprite = $AnimatedSprite2D 
	sprite.play("Hit")
	stop_update = true
	await $AnimatedSprite2D.animation_finished
	stop_update = false
	
	if health != 0:
		die()
		
func _update_animations():
	var sprite = $AnimatedSprite2D 
		
	if velocity.x != 0 or velocity.y != 0:
		sprite.play("Move")
	else:
		sprite.play("default")

	if velocity.x > 0:
		sprite.flip_h = false 
	elif velocity.x < 0:
		sprite.flip_h = true  

#Pathfinding and animation updates
func _physics_process(_delta: float) -> void:
	if stop_update == false:
		_update_animations()
	if not player:
		return
		
	nav_agent.target_position = player.global_position
	
	if nav_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * speed 
	
	velocity = new_velocity
	move_and_slide()
