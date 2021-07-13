extends FSMTolo

export var max_distance := 1000.0
export var min_step := 100
export var max_step := 300
export var walk_speed := 100
export var walk_time := 2.0
export (PackedScene) var snake_part
export var snake_tex : Texture

var body_region := Rect2(37, 466, 486, 385)
var heel_region := Rect2(519, 504, 483, 390)
var tail_region := Rect2(519, 21.5, 437, 436)

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
var body_parts := []

func _ready():
	set_state('move')
	call_deferred("_setup_body")

func _setup_body():
	var scene = get_tree().current_scene
	
	# Body 1 setup
	var body1 = snake_part.instance() as SnakePart
	body1.init(snake_tex, parent, body_region, PI/2, 40)
	body1.max_target_distance = 30
	scene.add_child(body1)
	body1.position = parent.position
	body_parts.append(body1)
	
	# Heel setup
	var heel = snake_part.instance() as SnakePart
	heel.init(snake_tex, body1, heel_region, PI, 0)
	scene.add_child(heel)
	heel.position = body1.position
	body_parts.append(heel)
	
	# Body 2 setup
	var body2 = snake_part.instance() as SnakePart
	body2.init(snake_tex, heel, body_region, 1.5*PI, 0)
	scene.add_child(body2)
	body2.position = heel.position
	body_parts.append(body2)
	
	# Tail setup
	var tail = snake_part.instance() as SnakePart
	tail.init(snake_tex, body2, tail_region, 2*PI, 0)
#	tail.scale *= 0.5
	scene.add_child(tail)
	tail.position = body2.position
	body_parts.append(tail)

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
		
	$Arrow.set_dir(walk_dir)
	parent.facing = walk_dir.x
	print(str(movement.speed.x))
	animator.play("Walk")
	$Timer.start(walk_time)

var stop_chance := 0.1
export var stop_chance_increase := 0.05
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
			for part in body_parts:
				part.inflate()
			

func _state_process(delta):
	match state:
		'move':
			var head_sprite = parent.get_node('Sprites/Head') as Sprite
			if sign(movement.speed.x) > 0 != head_sprite.flip_h:
				head_sprite.flip_h = !head_sprite.flip_h
#			print(parent.scale.x)
#			parent.scale.x = -sign(movement.speed.x) # if movement.speed.x != 0 else 1.0

func _exit_state(old_state):
	match old_state:
		'move':
			pass
		'stink':
			stop_chance = 0.0
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

func _on_Health_died():
	for part in body_parts:
		part.queue_free()
