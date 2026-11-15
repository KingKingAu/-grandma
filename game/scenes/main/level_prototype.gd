extends Node2D

@export var main: Node2D
@export var player_number := 1 ## PLAYER 1 OR 2
var speed_modifier: = 1.0

@export var start_speed := 10.0
@export var speed := 10.0
@export var tile_size := 80.0
const HALF_WIDTH = 1280 / 2.0

var lanes = [-100, -20, 60, 140]

var patterns = [
	# top, middle, middle, bottom rows
	[0, 0, 1, 0],
	[0, 1, 0, 1],
	[0, 0, 1, 1],
	[0, 1, 1, 1],
	[0, 0, 0, 1],
	[0, 1, 0, 0],
	[0, 0, 0, 1],
	[0, 0, 0, 0]
]

var next_x = -HALF_WIDTH
var current_pattern := [0, 0, 0, 1]
var stretch_remains := 18
var is_transition_gap := false

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#for i in range(18):
		#spawn_tile(next_x, lanes[-1])
		#next_x += tile_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	while next_x + position.x < HALF_WIDTH + tile_size:
		if stretch_remains <= 0:
			next_stretch()
		
		for row in range(4):
			if current_pattern[row] == 1:
				spawn_tile(next_x, lanes[row])
				
		next_x += tile_size
		stretch_remains -= 1
	
	for block in get_children():
		if block.global_position.x < -HALF_WIDTH * 10 - tile_size:
			block.queue_free()


func _physics_process(delta: float) -> void:
	
	if player_number == 1:
		if !main.is_recording1:
			return
	else:
		if !main.is_recording2:
			return
	
	var direction: float
	
	direction = Input.get_axis(str(player_number) + "_left", str(player_number) + "_right")
	
	if Input.is_action_pressed(str(player_number) + "_reverse"):
		speed_modifier = clamp(speed_modifier - delta, 1.0/3.0, 1.0)
		speed = start_speed
	else:
		speed_modifier = clamp(speed_modifier + delta / 5, 0.0, 1.0)
	
	var current_speed: float
	if direction:
		current_speed = lerp(current_speed, -direction * speed * speed_modifier, .8)
		speed = clamp(speed * 1.001, start_speed, 17.0)
	else:
		current_speed = lerp(current_speed, 0.0, .7)
	
	position.x += current_speed
	
func spawn_tile(x, y):
	var tile = StaticBody2D.new()
	tile.position = Vector2(x, y - tile_size / 2.0)
	tile.collision_layer = player_number
	tile.collision_mask = player_number
	
	var colour = ColorRect.new()
	colour.size = Vector2(tile_size, tile_size)
	tile.add_child(colour)
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(tile_size, tile_size)
	collision.shape = shape
	collision.position = Vector2(tile_size / 2.0, tile_size / 2.0)
	tile.add_child(collision)
	
	add_child(tile)

func next_stretch() -> void:
	if !is_transition_gap:
		current_pattern = [[0, 0, 0, 0], [0, 0, 0, 1]].pick_random()
		is_transition_gap = true
		stretch_remains = randi_range(2, 4)
		return
	
	is_transition_gap = false
	var next_pat: Array = patterns.pick_random()
	
	while next_pat == [0, 0, 0, 0]:
		next_pat = patterns.pick_random()
	
	stretch_remains = randi_range(3, 6)
	current_pattern = next_pat
