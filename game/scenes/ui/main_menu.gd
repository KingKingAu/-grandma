extends Control

@export var bg: TileMap
@export var menu: Control
@export var canvasgroup: CanvasGroup

@export var custom_time: LineEdit

@export var music: AudioStreamPlayer

var starting := false

func _ready() -> void:
	music.volume_linear = 0
	create_tween().tween_property(music, "volume_linear", 1, 2)
	music.play()
	canvasgroup.self_modulate = Color(1, 1, 1, 0)
	menu.modulate = Color(1, 1, 1, 0)
	starting = false
	
	animation()

func _process(delta: float) -> void:
	if starting:
		return

func animation():
	
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

func start(time):
	
	var tween = create_tween().set_parallel()
	tween.tween_property(canvasgroup, "self_modulate", Color(1, 1, 1, 0), 1)
	tween.tween_property(music, "volume_linear", 0.1, 2)
	await tween.finished
	
	Autoload.game_length = time
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_30_pressed() -> void:
	if starting:
		return
	starting = true
	start(30.0)

func _on_60_pressed() -> void:
	if starting:
		return
	starting = true
	start(60.0)

func _on_custom_pressed() -> void:
	if starting:
		return
	starting = true
	start(float(custom_time.text))
