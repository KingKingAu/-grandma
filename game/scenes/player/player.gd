extends CharacterBody2D

@export var main: Node2D

@export var player_number := 1 ## PLAYER 1 OR 2

@export var JUMP_VELOCITY = -400.0
@export var coyote_time := 0.1
@export var jump_buffer_time := 0.15
@export var coyote_timer: Timer
@export var jump_buffer_timer: Timer

@export var target_x = -400

var speed_modifier: = 1.0
var was_on_floor: bool = false

func _physics_process(delta: float) -> void:
	if was_on_floor and !is_on_floor() and velocity.y >= 0.0:
		coyote_timer.start(coyote_time)
	
	if Input.is_action_just_pressed(str(player_number) + "_up"):
		jump_buffer_timer.start(jump_buffer_time)
	
	if (is_on_floor() or coyote_timer.time_left) and jump_buffer_timer.time_left:
		velocity.y = JUMP_VELOCITY * speed_modifier
		coyote_timer.stop()
		jump_buffer_timer.stop()
	
	elif Input.is_action_just_released(str(player_number) + "_up") and velocity.y < 0:
		velocity.y /= 2.0
	
	if not is_on_floor():
			velocity += get_gravity() * delta
	
	velocity.x = (target_x - position.x) * 10.0
	
	was_on_floor = is_on_floor()
	
	if (player_number == 1 and main.is_recording1) or (player_number == 2 and main.is_recording2):
		move_and_slide()
