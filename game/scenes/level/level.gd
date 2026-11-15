extends Node2D

@export var player_number := 1 ## PLAYER 1 OR 2
@export var platforms: PackedScene
@export var SPEED = 10.0

var speed_modifier: = 1.0

var current_stage = 1

@export var tile_size = 80

func _ready() -> void:
	spawn(-120.0, 70.0, 800.0, 80.0)
	
	for i in range(1, 5):
		var x = randi_range(-120, 1280)
		x = snapped(x, 80) + (current_stage + i) * 1280
		print(x)
		var y = randi_range(-100, 140)
		y = snapped(y, 80)
		
		var width = randi_range(80, 1280)
		width = snapped(width, 80)
		var height = 80
		
		spawn(x, y, width, height)
	

func _process(delta: float) -> void:
	if position.x < -1280 * current_stage:
		current_stage += 1
	



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

func spawn(x, y, width, height):
	var platform = StaticBody2D.new()
	platform.position = Vector2(x, y)
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(width, height)
	collision.shape = shape
	collision.position = Vector2(x, y)
	platform.add_child(collision)
	
	var colour = ColorRect.new()
	colour.size = Vector2(width, height)
	colour.position = Vector2(x, y) - Vector2(width / 2.0, height / 2.0)
	platform.add_child(colour)
	
	add_child(platform)
