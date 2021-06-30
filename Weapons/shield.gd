extends Weapon

	
func _input(event):
	if event.is_action_pressed("shield"):
		player.get_fsm().set_state('guard')
	
	if event.is_action_released("shield"):
		player.get_fsm().set_state('unguard')

func guard(guarding):
	$Shape.disabled = not guarding
