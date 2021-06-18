extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _physics_process(delta):
	
	print(axisX)
	get_parent().instant_speed = Vector2(20 * axisX, 0)
#		get_parent().instant_speed = Vector2(0, 0)
