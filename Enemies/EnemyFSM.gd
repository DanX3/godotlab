extends KinematicBody2D

class_name EnemyFSM

export (int) var touch_damage

var player : KinematicBody2D
var facing := 1.0

func _ready():
	randomize()

func _on_Hitbox_body_entered(body):
	print("hit by " + body.name)
	if body is Player:
		(body as Player).get_health().take_damage(touch_damage)
		return
		
	if body is Weapon:
		$Health.take_damage((body as Weapon).damage)

func _physics_process(delta):
	var speed = $Movement.physics_process(delta, facing)
	move_and_slide(speed)

func _on_Health_died():
	queue_free()
