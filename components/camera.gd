extends Camera2D

export var amount := 10.0
export var shake_interval := 0.2
export var shake_duration := 0.5
export var decay := 0.25
export var frequency := 30
var start_pos: Vector2
var shaking := false
var current_shaking: float
var current_interval: float
var current_duration: float

func _ready():
	start_pos = position

func shake():
	shaking = true
	smoothing_enabled = false
	current_shaking = amount
	current_interval = 0.0
	current_duration = shake_duration

func _make_shake_effect(delta):
	current_duration -= delta
	if current_interval > 0:
		return
	
	position.y = start_pos.y + (current_duration / shake_duration) * amount * sin(frequency * OS.get_ticks_msec())
	
#	current_interval += shake_interval
#	var angle = fmod(randf(), 2.0 * PI)
#	var r = shake_amount * (0.5 + 0.5 * randf())
#	position = r * Vector2(cos(angle), sin(angle))
##	var shakeX = (randf() * 2.0 * shake_amount) - shake_amount
##	var shakeY = (randf() * 2.0 * shake_amount) - shake_amount
##	position = start_pos + Vector2(shakeX, shakeY)
	print("moved camera to %s" % str(position))
	
	if current_duration <= 0.0:
		# reset camera status
		shaking = false
		position = Vector2.ZERO
		smoothing_enabled = true
		position = start_pos
		

func _process(delta):
	pass
	if shaking:
		_make_shake_effect(delta)
		
	
	
