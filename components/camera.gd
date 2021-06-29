extends Node2D

export var shake_amount := 10.0
export var shake_interval := 0.2
export var shake_duration := 0.5
var start_pos: Vector2
var shaking := false
var current_shaking: float
var current_interval: float
var current_duration: float

func _ready():
	start_pos = position

func shake():
	print("shaking")
	shaking = true
	current_shaking = shake_amount
	current_interval = 0.0
	current_duration = shake_duration


func _process(delta):
	if shaking:
		current_duration -= delta
		current_interval -= delta
		if current_interval > 0:
			return
		
		current_interval += shake_interval
		var shakeX = (randf() * 2.0 * shake_amount) - shake_amount
		var shakeY = (randf() * 2.0 * shake_amount) - shake_amount
		position = start_pos + Vector2(shakeX, shakeY)
		print("moved camera to %s" % str(position))
		if current_duration <= 0.0:
			shaking = false
			position = Vector2.ZERO
