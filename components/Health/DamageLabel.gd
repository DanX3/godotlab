extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var show_time_msec: float = 2.0
export var speed: float = 2.0


# Called when the node enters the scene tree for the first time.

var spawn_time: float
func _ready():
	spawn_time = OS.get_ticks_msec()


func set_damage(damage: int, object: Node2D):
	text = str(damage)
	var pos = object.get_global_transform_with_canvas().get_origin()
	rect_position = pos + Vector2(0, 0) + rect_size * Vector2(-0.5, -1)
	

func _process(delta):
	rect_position -= Vector2(0, speed * delta)
	if OS.get_ticks_msec() - spawn_time > show_time_msec:
		queue_free()
