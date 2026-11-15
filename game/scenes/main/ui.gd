extends Control

@export var main: Node2D

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
	
	score1.text = str(roundi(-level1.position.x / 100))
	score2.text = str(roundi(-level2.position.x / 100))
