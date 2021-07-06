extends Node2D

class_name FSMTolo

var previous_state = null
var state = null
var states = {}
var transitions = {}

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass

func _state_process(delta):
	pass
	
func _get_transition(delta):
	return null
	
func set_state(new_state):
	# adds the state if not existing
	if !states.has(new_state):
		add_state(new_state)
		
	if not transitions != null and not new_state in transitions[state]:
		printerr('No transition from %s to %s' % [state, new_state])
		return
		
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	
	if new_state != null:
		_enter_state(new_state, previous_state)
		
func add_state(state_name):
	states[state_name] = states.size()
	
func _physics_process(delta):
	if state != null:
		_state_process(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)
		
