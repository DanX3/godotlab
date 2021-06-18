extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var jump_force := 100
var controller: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	controller = get_parent()

func _input(event):
	if event.is_action_pressed("jump") and controller.is_on_floor():
		controller.instant_speed = Vector2(0, -jump_force)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
