extends CharacterBody2D 

#lisää kuoleminen ja sen animaatiot

@onready var sword_pivot: Node2D = $SwordPivot
@onready var sword_area: Area2D = $SwordPivot/Sword
@export var speed = 150
@export var roll_speed = 200

@export var player_hp = 3

var is_rolling = false
var stop_update = false

func get_input(): # Function for checking input. Will be called later every physics tick
	if not is_rolling:
		var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
		velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	check_roll() 
	move_and_slide()
	
	if not stop_update:
		_update_animations()
	
func check_roll():
	if Input.is_action_just_pressed("Space") and not is_rolling:
		is_rolling = true
		velocity = velocity.normalized() * roll_speed 
		$AnimatedSprite2D.play("Roll")
		
		set_collision_mask_value(3, false)
		
		sword_pivot.visible = false
		sword_area.set_deferred("monitoring", false)
		sword_pivot.set_process(false)
		

func player_take_damage():
	var sprite = $AnimatedSprite2D 
	
	if stop_update or player_hp <= 0 or is_rolling:
		return
	
	player_hp -= 1
	print("I took damage. HP left: ", player_hp)
	
	if player_hp <= 0:
		print("I died... too bad")
		get_tree().change_scene_to_file("res://Scenes/Dungeon.tscn")
		return
	
	stop_update = true
	sprite.play("Damage")
	await sprite.animation_finished
	stop_update = false
	
func _update_animations():
	var sprite = $AnimatedSprite2D 
	
	if is_rolling:
		return 
		
	if velocity.x != 0 or velocity.y != 0:
		sprite.play("Move")
	else:
		sprite.play("default")

	if velocity.x > 0:
		sprite.flip_h = false 
	elif velocity.x < 0:
		sprite.flip_h = true  

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "Roll":
	
		is_rolling = false 
		velocity = Vector2.ZERO
		set_collision_mask_value(3, true)
		sword_pivot.visible = true
		sword_area.set_deferred("monitoring", true)
		sword_pivot.set_process(true)
		
