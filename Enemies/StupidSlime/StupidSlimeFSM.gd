extends FSMTolo

onready var parent: KinematicBody2D = get_parent()

export var sleep_time := 1.0
export var walk_time := 3.0
var facing := 1
var sleep_left := 0.0
export var speed = 10.0
var walk_left := 0.0

func _ready():
	add_state("sleep")
	add_state("walk")
	call_deferred("set_state", "sleep")

func _enter_state(new_state, old_state):
	print("entered state " + new_state)
	$Label.text = new_state
	match new_state:
		'sleep':
			sleep_left = sleep_time
		'walk':
			walk_left = walk_time
			facing = -1 if randf() < 0.5 else 1

func _exit_state(old_state, new_state):
	pass

func _state_process(delta):
	match state:
		'sleep':
			pass
		'walk':
			(parent as KinematicBody2D).move_and_slide(speed * Vector2(facing, 0))
	
func _get_transition(delta):
	match state:
		'sleep':
			sleep_left -= delta
			if sleep_left <= 0:
				return "walk"
		'walk':
			walk_left -= delta
			if walk_left <= 0:
				return "sleep"


func _on_Timer_timeout():
	set_state("walk")
