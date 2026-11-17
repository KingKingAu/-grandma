extends Control

@export var main: Node2D
@export var timer: Label

@export_group("Player 1")
@export var score1: Label
@export var level1: Node2D

@export_group("Player 2")
@export var score2: Label
@export var level2: Node2D

var labels = []
var original_positions = []

func _ready() -> void:
	labels = [timer, score1, score2]
	await get_tree().process_frame
	for label in labels:
		original_positions.append(label.global_position)

func _process(delta: float) -> void:
	
	if !main.game_on:
		return
	
	if !level1.disabled:
		main.score1 = roundi(-level1.position.x / 100)
	if !level2.disabled:
		main.score2 = roundi(-level2.position.x / 100)
	score1.text = str(main.score1)
	score2.text = str(main.score2)
	
	timer.text = str(roundi(main.timer.time_left + 0.25))
	
	var shake_intensity = 1
	
	if main.timer.time_left <= 3:
		shake_intensity = 10
	elif main.timer.time_left <= 5:
		shake_intensity = 5
	elif main.timer.time_left <= 10:
		shake_intensity = 3
	
	for label in labels:
		var original_position = original_positions[labels.find(label)]
		var offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		var tween = create_tween()
		tween.tween_property(label, "global_position", original_position + offset, 0.04)
		tween.tween_property(label, "global_position", original_position, 0.04)
