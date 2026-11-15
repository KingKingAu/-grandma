extends Node2D

@export var player1: CharacterBody2D
@export var player2: CharacterBody2D
@export var level1: Node2D
@export var level2: Node2D

var player_pos1 := []
var player_pos2 := []

var level_pos1 := []
var level_pos2 := []

var is_recording1 := true ## rewinding will be when it is false
var is_recording2 := true ## rewinding will be when it is false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_recording1:
		if player_pos1.size() > 300:
			player_pos1.pop_front()
		if level_pos1.size() > 300:
			level_pos1.pop_front()
		
		player_pos1.append(player1.position)
		level_pos1.append(level1.position)

	if is_recording2:
		if player_pos2.size() > 300:
			player_pos2.pop_front()
		if level_pos2.size() > 300:
			level_pos2.pop_front()
			
		player_pos2.append(player2.position)
		level_pos2.append(level2.position)
	
	if Input.is_action_pressed("1_reverse") and player_pos1.size() > 0 and level_pos1.size() > 0:
		is_recording1 = false
		player1.position = player_pos1[-1]
		player_pos1.pop_back()
		level1.position = level_pos1[-1]
		level_pos1.pop_back()
	else:
		is_recording1 = true

	if Input.is_action_pressed("2_reverse") and player_pos2.size() > 0 and level_pos2.size() > 0:
		is_recording2 = false
		player2.position = player_pos2[-1]
		player_pos2.pop_back()
		level2.position = level_pos2[-1]
		level_pos2.pop_back()
	else:
		is_recording2 = true
