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


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("1_reverse") and player_pos1.size() > 0 and level1.rewind_metre.value > 0.0:
		is_recording1 = false
		player1.position = player_pos1.pop_back()
		level1.position = level_pos1.pop_back()
	else:
		is_recording1 = true
		if player_pos1.size() >= 300:
			player_pos1.pop_front()
			level_pos1.pop_front()
		player_pos1.append(player1.position)
		level_pos1.append(level1.position)
	level1.rewind_metre.value = level_pos1.size() / 300.0

	if Input.is_action_pressed("2_reverse") and player_pos2.size() > 0:
		is_recording2 = false
		player2.position = player_pos2.pop_back()
		level2.position = level_pos2.pop_back()
	else:
		is_recording2 = true
		if player_pos2.size() >= 300:
			player_pos2.pop_front()
			level_pos2.pop_front()
		player_pos2.append(player2.position)
		level_pos2.append(level2.position)
	level2.rewind_metre.value = level_pos2.size() / 300.0
