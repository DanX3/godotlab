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

func end_attack():
	print("end attack")
	$Shape.disabled = true
