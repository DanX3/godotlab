extends FSMTolo

var found_player := false
var player : Player

func _get_target():
	if player == null:
		return start_pos
	else:
		return player.position

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass

func _state_process(delta):
	pass

func _ready():
	pass
