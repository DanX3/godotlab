extends KinematicBody2D

class_name Player
var speed: Vector2
onready var accel: Vector2 = Vector2(0, 20)
export var walk_speed: int
export var max_speed : Vector2
export var friction: int
export var gravity := 100
export var jump_force := 100

func _ready():
	pass
	
func _input(event):
	if event.is_action_pressed("jump") and is_on_floor():
		$Movement.instant_speed = Vector2(0, -jump_force)
	
#	if event.is_action_pressed("attack_1"):
#		$AnimationPlayer.play("Attack1")

func step(d: float, x: float) -> float:
	return 0.0 if x < d else 1.0;

func _physics_process(delta):
	var axisX = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var speed = $Movement.physics_process(delta, axisX)
	move_and_slide(speed, Vector2(0, -1))
#	animate_movement()
	
	if is_on_floor():
		$Movement.speed.y = 1

func animate_movement():
	if $AnimationPlayer.current_animation == "Attack1":
		return
		
	if abs($Movement.speed.x) < 10.0:
		if $AnimationPlayer.current_animation != "Idle":
			$AnimationPlayer.play("Idle")
		$Movement.speed.x = 0
	elif $AnimationPlayer.current_animation != "Run":
		$AnimationPlayer.play("Run")
		scale = Vector2(sign($Movement.speed.x), 1)
		rotation = 0

func save(game_data: GameData):
	game_data.game_data['player'] = [position, $Health.health]

func load(game_data: GameData):
	position = game_data.game_data['player'][0]
	$Health.health = game_data.game_data['player'][1]

func get_health() -> Health:
	return $Health as Health

func get_score() -> Score:
	return $Score as Score


func _on_Health_damaged():
	$Camera2D.shake()

func get_fsm() -> FSMTolo:
	return $FSMTolo as FSMTolo
