extends Node2D

@export var main: Node2D
@export var player_number := 1 ## PLAYER 1 OR 2
var speed_modifier: = 1.0

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
var last_was_gap := false
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
		position.x -= direction * speed * speed_modifier

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
	if !is_transition_gap and !last_was_gap:
		current_pattern = [[0, 0, 0, 0], [0, 0, 0, 1]].pick_random()
		is_transition_gap = true
		stretch_remains = 1
		return
	
	is_transition_gap = false
	var next_pat: Array = patterns.pick_random()
	
	while next_pat == [0, 0, 0, 0] and last_was_gap:
		next_pat = patterns.pick_random()
	
	if current_pattern == [0, 0, 0, 0]:
		last_was_gap = true
		stretch_remains = randi_range(1, 3)
	else:
		last_was_gap = false
		stretch_remains = randi_range(3, 6)
	
	current_pattern = next_pat
