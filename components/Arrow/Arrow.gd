extends Sprite


func _ready():
	pass # Replace with function body.

func set_dir(direction: Vector2):
	if (direction.x > 0) != (scale.x > 0):
		scale.x *= -1.0
