extends CharacterBody2D

@export var player_number := 1 ## PLAYER 1 OR 2

@export var JUMP_VELOCITY = -400.0

var speed_modifier: = 1.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if player_number == 1:
		if Input.is_action_just_pressed("1_up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif Input.is_action_just_released("1_up") and velocity.y < 0:
			velocity.y /= 2.0
		
		if Input.is_action_pressed("1_reverse"):
			speed_modifier = clamp(speed_modifier - delta, 0.0, 1.0)
		else:
			speed_modifier = clamp(speed_modifier + delta / 5, 0.0, 1.0)
		
	else:
		if Input.is_action_just_pressed("2_up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif Input.is_action_just_released("2_up") and velocity.y < 0:
			velocity.y = 0
			
		if Input.is_action_pressed("2_reverse"):
			speed_modifier = clamp(speed_modifier - delta, 0.0, 1.0)
		else:
			speed_modifier = clamp(speed_modifier + delta / 5, 0.0, 1.0)


	move_and_slide()
