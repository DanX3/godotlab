extends Node

class_name Movement

export var walk_speed: int
export var max_speed : Vector2
export var friction: int
export var gravity := 100
export var jump_force := 100
onready var accel: Vector2 = Vector2(0, 20)
var instant_speed: Vector2
var speed: Vector2
export (NodePath) var bodyPath
onready var body: KinematicBody2D = get_node(bodyPath)
var locked := false

func _ready():
	pass

func physics_process(delta, axisX) -> Vector2:
	if locked:
		return speed
	
	axisX = clamp(axisX, -1.0, 1.0)
	accel.x = axisX * walk_speed
	accel.y = 1 if body.is_on_floor() else gravity
	speed += accel * delta + instant_speed
	speed.x -= delta * friction * sign(speed.x)
	speed.x = clamp(speed.x, -max_speed.x, max_speed.x) #* step(abs(speed.x), 1.0)
	speed.y = clamp(speed.y, -max_speed.y, max_speed.y)
	instant_speed = Vector2.ZERO
	return speed
	
func lock():
	locked = true
	speed = Vector2.ZERO
	accel = Vector2.ZERO

func unlock():
	locked = false
