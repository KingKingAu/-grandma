extends Control

@export var bg: TileMap
@export var menu: Control

var starting := false

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	menu.modulate = Color(1, 1, 1, 0)
	starting = false
	
	animation()

func _process(delta: float) -> void:
	if starting:
		return
	

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
