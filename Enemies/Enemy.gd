extends KinematicBody2D

class_name Enemy

export (int) var touch_damage

var player : KinematicBody2D

func _ready():
	randomize()
	$FSM.set_trigger("start")

func _on_Hitbox_body_entered(body):
	print("hit by " + body.name)
	if body is Player:
		(body as Player).get_health().take_damage(touch_damage)
		pass
		
	if body is Weapon:
		$Health.take_damage((body as Weapon).damage)

func _on_Health_died():
	queue_free()


func _on_FSM_transited(from, to):
	pass # Replace with function body.
