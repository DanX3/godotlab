extends FSMTolo

export var max_distance := 1000.0
export var min_step := 100
export var max_step := 300
export var walk_speed := 100

var found_player := false
var player : Player
var walk_dir := Vector2(1, 0)
onready var tween :Tween = $'../Tween'
onready var space2d = get_world_2d().direct_space_state
onready var start_pos = get_parent().position
onready var movement = get_node('../Movement') as Movement
var stink_cloud = preload("res://Enemies/StinkySock/StinkCloud.tscn")
onready var parent :Node2D = get_parent()

func _ready():
	set_state('move')

func _get_target() -> Vector2:
	if player == null:
		return start_pos
	else:
		return player.global_position

func _get_walk_dir() -> Vector2:
	var target = _get_target()
	if abs(target.x - parent.position.x) > max_distance:
		print('towards target')
		return Vector2(sign(target.x - parent.position.x), 0)
	else:
		print('towards random')
		return Vector2(1.0 if randf() < 0.5 else -1.0, 0)

func _move_to_target():
	walk_dir = _get_walk_dir()
	$Arrow.set_dir(_get_walk_dir())
	# warning-ignore:return_value_discarded
	tween.interpolate_method(self, "_move", 0.0, 1.0, 2.0, Tween.TRANS_CIRC, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	tween.start()

func _move(value):
	parent.facing = value * walk_dir.x
	$Label.text = "facing: " + str(parent.facing)
	$Label.text += '\nlocked: ' + str(get_node("../Movement").locked)


func _enter_state(new_state):
	$Label.text = new_state
	match new_state:
		'move', 'follow':
			_move_to_target()
		'stink':
			print('entered stink')
			movement.lock()
			get_node('../AnimationPlayer').play("StinkCloud")
			$Timer.start(6.0)
			

func _state_process(__):
	match state:
		'move':
			pass
		'follow':
			pass
		'stink':
			pass

func _exit_state(old_state):
	match old_state:
		'move', 'follow':
			stop_chance = 0.0
		'stink':
			movement.unlock()


var stop_chance := 0.0
export var stop_chance_increase := 0.1
func _on_Tween_tween_all_completed():
	match state:
		'move', 'follow':
			stop_chance += stop_chance_increase
			if randf() < stop_chance:
				set_state('stink')
			else:
				if player != null:
					set_state('follow')
				_move_to_target()


func _on_PlayerDetection_body_entered(body):
	if body is Player:
		player = body as Player
	
func _spawn_cloud():
	owner.add_child(stink_cloud.instance())


func _on_Timer_timeout():
	if player == null:
		set_state('move')
	else:
		set_state('follow')
