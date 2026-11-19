extends Control

@export var black: ColorRect
@export var bg: TileMap
@export var menu: Control
@export var canvasgroup: CanvasGroup

@export var lab_score1: Label
@export var lab_score2: Label

@export var result: Label

var main: Node2D

func _ready() -> void:
	black.modulate = Color(1, 1, 1, 0)
	canvasgroup.self_modulate = Color(1, 1, 1, 0)
	menu.modulate = Color(1, 1, 1, 0)
	
	lab_score1.text = str(main.score1)
	lab_score2.text = str(main.score2)
	
	if main.score1 > main.score2:
		result.text = "Player 1 WINS!"
	elif main.score2 > main.score1:
		result.text = "Player 2 WINS!"
	else:		result.text = "TIE!"
	
	animation()


func _process(delta: float) -> void:
	pass

func animation():
	
	var tween_black = create_tween()
	tween_black.tween_property(black, "modulate", Color(1, 1, 1), 1)
	await tween_black.finished
	
	var tween_mod = create_tween()
	tween_mod.tween_property(canvasgroup, "self_modulate", Color(1, 1, 1), 1)
	await tween_mod.finished
	
	var tween_bg = create_tween()
	tween_bg.tween_property(bg, "position:y", 0, 1)
	await tween_bg.finished
	
	for i in 10:
		bg.position = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		await get_tree().create_timer(0.02).timeout
	bg.position = Vector2.ZERO
	
	var tween_menu = create_tween()
	tween_menu.tween_property(menu, "modulate", Color(1, 1, 1), 1)
	await tween_menu.finished
	
	await get_tree().create_timer(3).timeout
	
	var fade = create_tween().set_parallel()
	fade.tween_property(canvasgroup, "self_modulate", Color(1, 1, 1, 0), 1)
	fade.tween_property(main.music, "volume_linear", 0.1, 2)
	await fade.finished
	
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
