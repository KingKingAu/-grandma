extends Node2D

@export var player_number := 1 ## PLAYER 1 OR 2

@export var SPEED = 10.0

var speed_modifier: = 1.0

func _process(delta: float) -> void:
	pass
	# do random generation thing


func _physics_process(delta: float) -> void:
	var direction: float
	
	if player_number == 1:
		direction = Input.get_axis("1_left", "1_right")
		
		if Input.is_action_pressed("1_reverse"):
			speed_modifier = clamp(speed_modifier - delta, 0.0, 1.0)
		else:
			speed_modifier = clamp(speed_modifier + delta / 5, 0.0, 1.0)
		
	else:
		direction = Input.get_axis("2_left", "2_right")
		
		if Input.is_action_pressed("2_reverse"):
			speed_modifier = clamp(speed_modifier - delta, 0.0, 1.0)
		else:
			speed_modifier = clamp(speed_modifier + delta / 5, 0.0, 1.0)
	
	if direction:
		position.x -= direction * SPEED * speed_modifier
