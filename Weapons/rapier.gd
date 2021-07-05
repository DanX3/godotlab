extends Weapon


func _ready():
	pass

func _input(event):
	if event.is_action_pressed("attack_1"):
		player.get_fsm().set_state('attack_1')
		print('set attack_1')

func attack():
	print('attacked')
	$Shape.disabled = false
	var start = 7.54 if randf() < 0.5 else 8.32
	$AudioStreamPlayer2D.play(start)
	$Timer.start(0.8)

func end_attack():
	print("end attack")
	$Shape.disabled = true


func _on_Timer_timeout():
	$AudioStreamPlayer2D.stop()
