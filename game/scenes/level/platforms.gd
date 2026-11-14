extends StaticBody2D

var HEIGHT = 80

var width = 80

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	width = randi_range(80, 1280)
	$ColorRect.size.x = width
	$ColorRect.position.x = -width / 2
	$CollisionShape2D.shape.size.x = width
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
