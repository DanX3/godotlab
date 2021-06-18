extends KinematicBody2D

class_name Player
var speed: Vector2
onready var accel: Vector2 = Vector2(0, 20)
var instant_speed: Vector2
export var walk_speed: int
var max_speed := Vector2(100, 180)
export var friction: int
export var gravity := 100
export var jump_force := 100

func _ready():
	(get_node("/root/Singleton") as LabSingleton).camera = $Camera2D
	
	
func _input(event):
	if event.is_action_pressed("jump") and is_on_floor():
		instant_speed = Vector2(0, -jump_force)

func step(d: float, x: float) -> float:
	return 0.0 if x < d else 1.0;

func _physics_process(delta):
	var axisX = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	accel.x = axisX * walk_speed
	accel.y = 1 if is_on_floor() else gravity
	speed += accel * delta + instant_speed
	speed.x -= delta * friction * sign(speed.x)
	speed.x = clamp(speed.x, -max_speed.x, max_speed.x) #* step(abs(speed.x), 1.0)
	speed.y = clamp(speed.y, -max_speed.y, max_speed.y)
	if abs(speed.x) < 1.0:
		speed.x = 0
	instant_speed = Vector2(0, 0)
	move_and_slide(speed, Vector2(0, -1))
	
	if is_on_floor():
		speed.y = 1
	
	$Label.text = "Speed: " + str(speed) + "\nAccel: " + str(accel)# + "\nLife: " + str($Health.health)
#	position += speed * delta

func save(game_data: GameData):
	game_data.game_data['player'] = [position, $Health.health]

func load(game_data: GameData):
	position = game_data.game_data['player'][0]
	$Health.health = game_data.game_data['player'][1]

func get_health() -> Health:
	return $Health as Health

func get_score() -> Score:
	return $Score as Score
