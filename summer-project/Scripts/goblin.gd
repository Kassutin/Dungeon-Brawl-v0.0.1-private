extends CharacterBody2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

#KORJAA NÄMÄ 1. älä tee damagea kun ottaa damagea, toista damage kun pysyt paikoillasi

@export var speed: float = 100.0
@export var player: Node2D # Knows which node to navigate towardss
@export var health = 3
var stop_update = false


func _ready():
	await get_tree().physics_frame
	
	
func die():
	$Area2D.queue_free()
	set_physics_process(false)
	$CollisionShape2D.queue_free()
	velocity = Vector2.ZERO
	
	var sprite = $AnimatedSprite2D 
	sprite.play("Death")
	stop_update = true
	await $AnimatedSprite2D.animation_finished
	
	stop_update = false
	queue_free()
	
func take_damage():
	health -= 1
	print("ouch")	#Testing purposes
	var sprite = $AnimatedSprite2D
	
	if health <= 0:
		die()
	
	else:
		stop_update = true
		sprite.play("Hit")
		await sprite.animation_finished
		stop_update = false

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
		


func _on_area_2d_body_entered(body: Node2D):
	if body.has_method("player_take_damage"):
		body.player_take_damage()
		
		
