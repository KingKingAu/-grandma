extends Control

@export var main: Node2D
@export var timer: Label

@export_group("Player 1")
@export var score1: Label
@export var level1: Node2D

@export_group("Player 2")
@export var score2: Label
@export var level2: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	main.score1 = roundi(-level1.position.x / 100)
	main.score2 = roundi(-level2.position.x / 100)
	score1.text = str(main.score1)
	score2.text = str(main.score2)
	
	timer.text = str(int(main.timer.time_left))
	
