extends Node2D

@export var crown: Sprite2D
var winning_player: CharacterBody2D
@export var player1: CharacterBody2D
@export var player2: CharacterBody2D
@export var level1: Node2D
@export var level2: Node2D

@export var game_length := 30.0
@export var timer: Timer

@export var game_over_menu: PackedScene

@export var countdown: Label
@export var countsound: AudioStreamPlayer

@export var rewind1: Label
var rewind1_orig_pos: Vector2
@export var rewind2: Label
var rewind2_orig_pos: Vector2

@export var music: AudioStreamPlayer

var player_pos1 := []
var player_pos2 := []

var level_pos1 := []
var level_pos2 := []

var fliph1 := []
var fliph2 := []

var is_recording1 := true ## rewinding will be when it is false
var is_recording2 := true ## rewinding will be when it is false

var game_on := false

var score1 := 0
var score2 := 0

func _ready() -> void:
	
	game_length = Autoload.game_length
	music.volume_linear = 0
	game_on = true
	winning_player = player1
	await get_tree().process_frame
	game_on = false
	countsound.play()
	await get_tree().create_timer(1).timeout
	countdown.text = "2"
	await get_tree().create_timer(1).timeout
	countdown.text = "1"
	await get_tree().create_timer(1).timeout
	countdown.text = "Go!"
	create_tween().tween_property(countdown, "modulate", Color(1, 1, 1, 0), .2)
	await get_tree().create_timer(.2).timeout
	
	game_on = true
	music.play()
	
	create_tween().tween_property(music, "volume_linear", 1, 2)
	create_tween().tween_property(countsound, "volume_linear", 0.1, 0.5)
	
	score1 = 0
	score2 = 0
	
	player_pos1 = []
	player_pos2 = []
	level_pos1 = []
	level_pos2 = []
	fliph1 = []
	fliph2 = []
	
	rewind1_orig_pos = rewind1.position
	rewind2_orig_pos = rewind2.position
	
	is_recording1 = true
	is_recording2 = true
	
	timer.start(game_length)

func _physics_process(delta: float) -> void:
	if !game_on:
		return
	
	var min_frames = 30

	if Input.is_action_pressed("1_reverse") and !level1.disabled and (!is_recording1 or player_pos1.size() >= min_frames) and player_pos1.size() > 2:
		is_recording1 = false
		
		create_tween().tween_property(rewind1, "modulate", Color(1, 1, 1, 1), 0.2)
		
		var tween = create_tween()
		for i in 10:
			var offset = Vector2(randf_range(-3.0, 3.0), randf_range(-3.0, 3.0))
			tween.tween_property(rewind1, "position", rewind1_orig_pos + offset, 0.03)
		rewind1.position = rewind1_orig_pos

		if player_pos1.size() > 1 and level_pos1.size() > 1 and fliph1.size() > 1:
			player1.position = player_pos1.pop_back()
			level1.position = level_pos1.pop_back()
			player1.anim.flip_h = fliph1.pop_back()
	else:
		is_recording1 = true
		
		create_tween().tween_property(rewind1, "modulate", Color(1, 1, 1, 0), 0.2)
		
		if player_pos1.size() >= 300:
			player_pos1.pop_front()
			level_pos1.pop_front()
			fliph1.pop_front()
		player_pos1.append(player1.position)
		level_pos1.append(level1.position)
		fliph1.append(player1.anim.flip_h)
	
	level1.rewind_metre.value = float(level_pos1.size() - 1) / 299.0
	print(player_pos2.size())
	if Input.is_action_pressed("2_reverse") and !level2.disabled and (!is_recording2 or player_pos2.size() >= min_frames) and player_pos2.size() > 2:
		is_recording2 = false
		
		create_tween().tween_property(rewind2, "modulate", Color(1, 1, 1, 1), 0.2)
		
		var tween = create_tween()
		for i in 10:
			var offset = Vector2(randf_range(-3.0, 3.0), randf_range(-3.0, 3.0))
			tween.tween_property(rewind2, "position", rewind2_orig_pos + offset, 0.03)
		rewind2.position = rewind2_orig_pos
		
		if player_pos2.size() > 1 and level_pos2.size() > 1 and fliph2.size() > 1:
			player2.position = player_pos2.pop_back()
			level2.position = level_pos2.pop_back()
			player2.anim.flip_h = fliph2.pop_back()
	else:
		is_recording2 = true
		
		create_tween().tween_property(rewind2, "modulate", Color(1, 1, 1, 0), 0.2)
		
		if player_pos2.size() >= 300:
			player_pos2.pop_front()
			level_pos2.pop_front()
			fliph2.pop_front()
		player_pos2.append(player2.position)
		level_pos2.append(level2.position)
		fliph2.append(player2.anim.flip_h)
	
	level2.rewind_metre.value = float(level_pos2.size() - 1) / 299.0
	
	if score1 > score2:
		winning_player = player1
		if crown.global_position.y <= -360:
			crown.hide()
		else:
			crown.show()
	elif score2 > score1:
		winning_player = player2
		if crown.global_position.y <= 0:
			crown.hide()
		else:
			crown.show()
	
	crown.reparent(winning_player)
	var tween = create_tween()
	tween.tween_property(crown, "global_position", winning_player.global_position + Vector2(0, -40), 0.2)

func game_over():
	
	if !game_on:
		return
	
	game_on = false
	
	var gom = game_over_menu.instantiate()
	
	gom.main = self
	
	gom.size = Vector2(1280, 720)
	
	add_child(gom)
	

func _on_death_1_body_entered(body: Node2D) -> void:
	score1 /= 1.5
	level1.disabled = true
	
	if timer.time_left > 5:
		timer.start(5)

func _on_death_2_body_entered(body: Node2D) -> void:
	score2 /= 1.5
	level2.disabled = true
	
	if timer.time_left > 5:
		timer.start(5)

func _on_timer_timeout() -> void:
	game_over()
