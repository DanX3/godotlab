extends Sprite

class_name SnakePart

var target: Node2D
export var max_target_distance := 50
export var y_period := 0.01
var y_offset := 0.0
var height_offset := 0.0
export var y_amplitude := 50

func init(tex: Texture, target: Node2D, region: Rect2, y_offset := 0.0, height_offset:= 0.0):
	texture = tex
	self.target = target
	if region != null:
		region_enabled = true
		self.region_rect = region
	self.y_offset = y_offset
	self.height_offset = height_offset

func _process(delta):
	if target == null:
		queue_free()
		return
	
	print(target == null)
	var distance = position.x - target.position.x
	if abs(distance) > max_target_distance:
		position.x = target.position.x + sign(distance) * max_target_distance
	if target.position.x - position.x > 0 != flip_h:
		flip_h = !flip_h
#	if (position.x - target.position.x) == sign(scale.x):
#		scale.x *= -1.0
		
	position.y = target.position.y + y_amplitude * sin(y_period * OS.get_ticks_msec() + y_offset) + height_offset

func inflate():
	$AnimationPlayer.play("Inflate")
