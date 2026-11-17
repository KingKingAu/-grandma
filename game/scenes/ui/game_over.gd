extends Control

@export var bg: TileMap
@export var menu: Control

@export var lab_score1: Label
@export var lab_score2: Label

@export var result: Label

var score1
var score2

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	menu.modulate = Color(1, 1, 1, 0)
	
	lab_score1.text = str(score1)
	lab_score2.text = str(score2)
	
	if score1 > score2:
		result.text = "Player 1 WINS!"
	elif score2 > score1:
		result.text = "Player 2 WINS!"
	else:		result.text = "TIE!"
	
	animation()


func _process(delta: float) -> void:
	pass

func animation():
	var tween_mod = create_tween()
	tween_mod.tween_property(self, "modulate", Color(1, 1, 1), 1)
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
