extends FSMTolo

export var max_distance := 1000.0
export var min_step := 100
export var max_step := 300
export var walk_speed := 100

var found_player := false
var player : Player
var walk_dir := Vector2(1, 0)
onready var tween :Tween = $'../Tween'
onready var raycast: RayCast2D = $'../RayCast2D'
onready var space2d = get_world_2d().direct_space_state
onready var start_pos = get_parent().position
var stink_cloud = preload("res://Enemies/StinkySock/StinkCloud.tscn")

func _ready():
	set_state('move')

func _get_target() -> Vector2:
	if player == null:
		return start_pos
	else:
		return player.position

func _get_walk_dir() -> Vector2:
	var target_dir = Vector2(sign(_get_target().x - get_parent().position.x), 0)
	var to_pos_chance = (_get_target().x - get_parent().position.x) / max_distance
	target_dir.x *= 1 if randf() < to_pos_chance or to_pos_chance < 0.0 else -1
	return target_dir


func _move_to_target():
	var pos = get_parent().position
	var target = _get_walk_dir() * (min_step + randf() * (max_step - min_step))
	var collision = space2d.intersect_ray(pos, pos + target)
	if not collision.empty() && collision.collider.name == "TileMap":
		target.x *= -1
	
	walk_dir = Vector2(sign(target.x - pos.x), 0)
	tween.interpolate_method(self, "_move", 0.0, 1.0, 3.0, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
#	tween.interpolate_property(get_parent(), "position", pos, pos + target, 2.0, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()

onready var speed_axis := 1.0
func _move(value):
	speed_axis = value
	get_parent().facing = value * walk_dir.x
#	speed = value * walk_dir.x

onready var movement = get_node('../Movement') as Movement
func non_physics_process(delta):
	if state in ['move', 'follow']:
#		print('speed: %f' % speed)
		print('speed_axis: %f' % speed_axis)
		get_parent().facing
#		var speed_x = movement.physics_process(delta, speed_axis * walk_dir.x)
#		get_parent().move_and_slide(speed_x * movement.max_speed.x, Vector2(0, -1))
		
		var parentBody = get_parent() as KinematicBody2D
		for i in range(parentBody.get_slide_count()):
			var c = parentBody.get_slide_collision(i)
			if c is Player:
				tween.stop_all()
				set_state('stink')
				break


func _enter_state(new_state, old_state):
	$Label.text = new_state
	match new_state:
		'move', 'follow':
			_move_to_target()
		'stink':
			movement.lock()
			get_node('../AnimationPlayer').play("StinkCloud")
			$Timer.start(6.0)
			

func _state_process(delta):
	match state:
		'move':
			pass
		'follow':
			pass
		'stink':
			pass

func _exit_state(old_state, new_state):
	match new_state:
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
