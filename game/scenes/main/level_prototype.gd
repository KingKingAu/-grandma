extends Node2D

@export var main: Node2D
@export var player_number := 1 ## PLAYER 1 OR 2
@export var players: Array[CharacterBody2D]
var player: CharacterBody2D
var speed_modifier: = 1.0
@export var rewind_metre: TextureProgressBar

@export var start_speed := 10.0
@export var speed := 10.0
var current_speed: float
@export var tile_size := 80.0

@export var parallax_layers: Array[Parallax2D] = []

const HALF_WIDTH = 1280 / 2.0

var lanes = [-20, 60, 140]

var patterns = [
	# top, middle, bottom rows
	[0, 1, 0],
	[1, 0, 1],
	[0, 1, 1],
	[1, 1, 1],
	[0, 0, 1],
	[1, 0, 0],
	[0, 0, 1],
	[0, 0, 0]
]

var next_x = -HALF_WIDTH
var current_pattern := [0, 0, 1]
var stretch_remains := 18
var is_transition_gap := false

var disabled := false

var seed: int
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	if Autoload.split_seed and player_number == 2:
		if Autoload.seed2 == "":
			seed = randi()
		else:
			seed = Autoload.seed2.hash()
	else:
		if Autoload.seed == "":
			seed = randi()
		else:
			seed = Autoload.seed.hash()
	
	rng.seed = seed
	
	current_pattern = [0, 0, 1]
	stretch_remains = 18
	is_transition_gap = false
	if player_number == 1:
		player = players[0]
	else:
		player = players[1]
	disabled = false
	
	while next_x + position.x < HALF_WIDTH + tile_size:
		if stretch_remains <= 0:
			next_stretch()
		
		var has_tile_above = false
		var has_tile_below = false
		for row in range(3):
			if current_pattern[row] == 1 and current_pattern[clamp(row+1, 0, 2)] == 1:
				has_tile_below = true
			if current_pattern[row] == 1:
				spawn_tile(next_x, lanes[row], has_tile_above, has_tile_below)
				has_tile_above = true
			else:
				has_tile_above = false
				
		next_x += tile_size
		stretch_remains -= 1
	
	for layer in parallax_layers:
		if layer:
			layer.scroll_offset.x = -global_position.x * layer.scroll_scale.x


func _process(delta: float) -> void:
	
	if !main.game_on or disabled:
		return
	
	while next_x + position.x < HALF_WIDTH + tile_size:
		if stretch_remains <= 0:
			next_stretch()
		
		var has_tile_above = false
		var has_tile_below = false
		for row in range(3):
			if current_pattern[row] == 1 and current_pattern[clamp(row+1, 0, 2)] == 1:
				has_tile_below = true
			if current_pattern[row] == 1:
				spawn_tile(next_x, lanes[row], has_tile_above, has_tile_below)
				has_tile_above = true
			else:
				has_tile_above = false
				
		next_x += tile_size
		stretch_remains -= 1
	
	for tile in get_children():
		if tile is StaticBody2D:
			if tile.global_position.x < -HALF_WIDTH * 10 - tile_size:
				tile.queue_free()
	
	for layer in parallax_layers:
		if layer:
			layer.scroll_offset.x = -global_position.x * layer.scroll_scale.x

func _physics_process(delta: float) -> void:
	
	if !main.game_on or disabled:
		return
	
	if player_number == 1:
		if !main.is_recording1:
			return
	else:
		if !main.is_recording2:
			return
	
	var direction: float
	
	direction = Input.get_axis(str(player_number) + "_left", str(player_number) + "_right")
	
	if Input.is_action_pressed(str(player_number) + "_reverse") and rewind_metre.value > 0.0:
		speed_modifier = clamp(speed_modifier - delta, 1.0/3.0, 1.0)
		speed = start_speed
	else:
		speed_modifier = clamp(speed_modifier + delta / 5, 0.0, 1.0)
	
	if direction:
		current_speed = lerp(current_speed, -direction * speed * speed_modifier, .8)
		speed = clamp(speed * 1.001, start_speed, 17.0)
		if player.is_on_floor():
			player.anim.play("run")
	else:
		current_speed = lerp(current_speed, 0.0, .1)
		if player.is_on_floor():
			player.anim.play("idle")
	
	player.anim.skew = -deg_to_rad(current_speed/1.5)
	player.anim.flip_h = current_speed > 0
	player.anim.speed_scale = speed_modifier
	position.x += current_speed

func spawn_tile(x, y, has_tile_above, has_tile_below):
	var tile = StaticBody2D.new()
	tile.position = Vector2(x, y - tile_size / 2.0)
	tile.collision_layer = player_number
	tile.collision_mask = player_number
	
	var colour = ColorRect.new()
	if player_number == 1:
		colour.color = Color("2e4e75")
	else:
		colour.color = Color("612b42")
	colour.size = Vector2(tile_size, tile_size)
	tile.add_child(colour)
	
	if !has_tile_above:
		var top = ColorRect.new()
		if player_number == 1:
			top.color = Color("71bcf3")
		else:
			top.color = Color("e27a87")
		top.size = Vector2(tile_size, tile_size/4)
		tile.add_child(top)
	
	if !has_tile_below:
		var bottom = ColorRect.new()
		if player_number == 1:
			bottom.color = Color("1c3250")
		else:
			bottom.color = Color("3f192a")
		bottom.size = Vector2(tile_size, tile_size/4)
		bottom.position.y = tile_size/2 + tile_size / 4
		tile.add_child(bottom)

	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(tile_size, tile_size)
	collision.shape = shape
	collision.position = Vector2(tile_size / 2.0, tile_size / 2.0)
	tile.add_child(collision)
	
	add_child(tile)

func next_stretch() -> void:
	if !is_transition_gap:
		current_pattern = [[0, 0, 0], [0, 0, 1]][rng.randi_range(0, 1)]
		is_transition_gap = true
		stretch_remains = rng.randi_range(2, 4)
		return
	
	is_transition_gap = false
	var next_pat: Array = patterns[rng.randi_range(0, patterns.size() - 1)]
	
	while next_pat == [0, 0, 0]:
		next_pat = patterns[rng.randi_range(0, patterns.size() - 1)]
	
	stretch_remains = rng.randi_range(3, 6)
	current_pattern = next_pat
