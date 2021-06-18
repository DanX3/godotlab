extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_StaticBody2D_body_entered(body):
	if $AnimationPlayer.current_animation == "":
		print("start playing")
		$AnimationPlayer.play("Move")
