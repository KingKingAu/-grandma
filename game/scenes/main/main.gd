extends Node2D

@export var player1: CharacterBody2D
@export var player2: CharacterBody2D
@export var level1: Node2D
@export var level2: Node2D

@export var game_length := 30.0
@export var timer: Timer

var player_pos1 := []
var player_pos2 := []

var level_pos1 := []
var level_pos2 := []

var is_recording1 := true ## rewinding will be when it is false
var is_recording2 := true ## rewinding will be when it is false

var game_on := true

var score1 := 0
var score2 := 0

var winner := 0 ## 0 is tie, 1 is player 1, 2 is player 2

func _ready() -> void:
	game_on = true
	
	winner = 0
	score1 = 0
	score2 = 0
	
	player_pos1 = []
	player_pos2 = []
	level_pos1 = []
	level_pos2 = []
	
	is_recording1 = true
	is_recording2 = true
	
	timer.start(game_length)

func _physics_process(delta: float) -> void:
	if !game_on:
		return
	
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

	if Input.is_action_pressed("2_reverse") and player_pos2.size() > 0 and level2.rewind_metre.value > 0.0:
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

func game_over():
	game_on = false
	
	if score1 > score2:
		winner = 1
	elif score2 > score1:
		winner = 2
	

func _on_death_1_body_entered(body: Node2D) -> void:
	$"level prototype".position.x = 999999999
	game_over()

func _on_death_2_body_entered(body: Node2D) -> void:
	$"level prototype2".position.x = 999999999
	game_over()

func _on_timer_timeout() -> void:
	game_over()
