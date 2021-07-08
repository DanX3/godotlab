extends Sprite

var target: Node2D
export var max_target_distance := 150
export var y_period := 0.01
export var y_amplitude := 50

var start_pos: Vector2

func _ready():
	start_pos = position

func init(tex: Texture, target: Node2D):
	texture = tex
	self.target = target

func _process(delta):
	var distance = position.x - target.position.x
	if abs(distance) > max_target_distance:
		position.x = target.position.x + sign(distance) * max_target_distance
	position.y = start_pos.y + y_amplitude * sin(y_period * OS.get_ticks_msec())
