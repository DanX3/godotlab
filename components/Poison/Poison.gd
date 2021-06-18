extends Node2D

export var damage: int
export var period_msec: int
export var duration_msec: int

var health
var last_call

# Called when the node enters the scene tree for the first time.
func _ready():
	if not get_parent().has_node("Health"):
		queue_free()
	health = $"../Health" as Health
	last_call = OS.get_ticks_msec()
	health.take_damage(damage)
	


func _process(delta):
	if OS.get_ticks_msec() > last_call + period_msec:
		print(delta)
		last_call += period_msec
		health.take_damage(damage)
	
	
	duration_msec -= 1000 * delta
	if duration_msec <= 0:
		queue_free()
