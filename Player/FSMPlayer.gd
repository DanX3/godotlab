extends FSMTolo

var player : Player
var animator : AnimationPlayer
var movement : Movement
var state_time_left := 0.0

func _ready():
	player = get_parent() as Player
	animator = $'../AnimationPlayer'
	movement = $'../Movement'
	add_state('idle')
	add_state('walk')
	add_state('attack_1')
	add_state('attack_2')
	add_state('attack_3')
	add_state('guard')
	call_deferred('set_state', 'idle')
	transitions = {
		'idle': ['walk', 'attack_1', 'guard'],
		'walk': ['idle', 'attack_1', 'guard'],
		'guard': ['unguard'],
		'unguard': ['idle', 'walk'],
	}

func _enter_state(new_state, old_state):
	$Label.text = new_state
	match new_state:
		'idle':
			$'../AnimationPlayer'.play("Idle")
		'walk':
			$'../AnimationPlayer'.play("Run")
		'attack_1':
			animator.play("Attack1")
#			state_time_left = animator.get_animation('Attack1').length
		'guard':
			unguarding = false
			animator.play("Guard")
			movement.lock()
		'unguard':
			animator.play_backwards('Guard')
			unguarding = true
#			state_time_left = animator.get_animation('Guard').length

func _exit_state(old_state, new_state):
	match new_state:
		'unguard':
			movement.unlock()
			set_state('idle')

func _state_process(delta):
	match state:
		'idle':
			if abs(movement.speed.x) > 10.0:
				set_state('walk')
		'walk':
			if abs(movement.speed.x) <= 10.0:
				set_state('idle')
			player.scale = Vector2(sign($'../Movement'.speed.x), 1)
			player.rotation = 0

func _get_transition(delta):
	return null
#	state_time_left -= delta
#	if state_time_left > 0:
#		return null
#
#	match state:

var unguarding = false
func _on_AnimationPlayer_animation_finished(anim_name):
	print('finished ' + anim_name)
	match anim_name:
		'Attack1', 'attack_2', 'attack_3':
			set_state('idle')
		'Guard':
			if unguarding:
				set_state('idle')
				unguarding = false
