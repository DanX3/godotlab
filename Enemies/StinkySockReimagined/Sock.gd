extends FSMTolo

export var max_distance := 1000.0
export var min_step := 100
export var max_step := 300
export var walk_speed := 100
export var walk_time := 2.0

var found_player := false
var player : Player
var walk_dir := Vector2(1, 0)
onready var tween :Tween = $'../Tween'
onready var space2d = get_world_2d().direct_space_state
onready var start_pos = get_parent().position
onready var movement = get_node('../Movement') as Movement
onready var animator = get_node('../AnimationPlayer')
var stink_cloud = preload("res://Enemies/StinkySock/StinkCloud.tscn")
onready var parent :Node2D = get_parent()
var snake_dir := -1.0

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
		return Vector2(sign(target.x - parent.position.x), 0)
	else:
		return Vector2(1.0 if randf() < 0.5 else -1.0, 0)

func _move_to_target(keep_dir: bool):
	if not keep_dir:
		walk_dir = _get_walk_dir()
		
	if walk_dir.x != snake_dir:
		set_state('turn')
		return
		
	$Arrow.set_dir(walk_dir)
	parent.facing = walk_dir.x
	if walk_dir.x > 0:
		animator.play("WalkBackwards")
	else:
		animator.play("Walk")
	$Timer.start(walk_time)

var stop_chance := 0.1
export var stop_chance_increase := 0.2
func _on_Timer_timeout():
	stop_chance += stop_chance_increase
	set_state('pause')
	if randf() < stop_chance:
		set_state('stink')
	else:
		set_state('move')

func _process(_delta):
	$Label.text = state + '\n'
	$Label.text += "facing: " + str(parent.facing) + '\n'
	$Label.text += 'snake_dir: %f\n' % snake_dir
	$Label.text += 'locked: ' + str(movement.locked)

var just_turned := false
func _enter_state(new_state):
	match new_state:
		'move':
			_move_to_target(just_turned)
			just_turned = false
		'stink':
			snake_dir = -1.0
			walk_dir.x = -1.0
			movement.lock()
			animator.play("StinkCloud")
		'turn':
			just_turned = true
			movement.lock()
			snake_dir = walk_dir.x
			parent.facing = snake_dir
			if snake_dir > 0.0:
				animator.play("Turn")
			else:
				animator.play_backwards("Turn")
			

func _exit_state(old_state):
	match old_state:
		'move':
			pass
		'stink':
			stop_chance = 0.0
			movement.unlock()
		'turn':
			movement.unlock()


func _on_PlayerDetection_body_entered(body):
	if body is Player:
		player = body as Player
	
func _spawn_cloud():
	var cloud = stink_cloud.instance()
	get_tree().current_scene.add_child(cloud)
	cloud.global_position = parent.global_position
#	owner.add_child(stink_cloud.instance())


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "StinkCloud":
		set_state('move')
	if anim_name == 'Turn':
		set_state('move')



