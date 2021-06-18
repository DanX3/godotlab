extends KinematicBody2D

onready var state = "Resting"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var need_move_target := true
var move_target : Vector2
export var move_speed := 15.0
export var walk_duration := 3.0
export var pause_duration := 1.0
var walking_dir := Vector2.LEFT
var player : KinematicBody2D
export var charge_distace := 40
export var attack_distance := 40


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$FSM.set_trigger("start")
	flip_x()
			

func _on_FSM_updated(state, delta):
	if state == "Entry":
		$FSM.set_trigger("start")
		return
		
	$Label.text = str(state)
	match state:
		"Resting":
			pass
		"Wandering":
			move_and_slide(move_speed * walking_dir)
		"SeenPlayer":
			walking_dir = Vector2(sign(player.position.x - position.x), 0)
			flip_x()
			move_and_slide(move_speed * walking_dir)
#		ATTACKING:
#			pass

func _on_FSM_transited(from, to):
	$Label.text = str(to)
#	print(from + " => " + to)
	match to:
		"Resting":
			$RestTimer.wait_time = pause_duration
			$RestTimer.start()
		"Wandering":
			$WalkTimer.wait_time = walk_duration
			$WalkTimer.start()
			if randf() < 0.5:
				walking_dir.x *= -1
				flip_x()
		"SeenPlayer":
			$AttackArea/Shape.disabled = false
		"Attacking":
			$AnimationPlayer.play("Attack")

func _on_Area2D_body_entered(body):
	if body is Player:
		player = body
		$FSM.set_trigger("seen_player")
	
func flip_x():
	if (walking_dir.x > 0) != ($Sprites.scale.x > 0):
		$Sprites.scale.x *= -1
		$HitArea/Shape.rotation_degrees += 180

func go_back():
	$AttackArea/Shape.disabled = true
	var target = position - charge_distace * walking_dir
	$Tween.interpolate_property(self, "position", position, target, 
		0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
		
func first_dash():
	var target = position + attack_distance * walking_dir
	$Tween.interpolate_property(self, "position", position, target, 
		0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()

func finish_attack():
	$FSM.set_trigger("finished_attacking")
	

func _on_AttackArea_body_entered(body):
	if body is Player:
		$FSM.set_trigger("attack")

func _on_RestTimer_timeout():
	print("Finished resting")
	$FSM.set_trigger("finished_resting")

func _on_WalkTimer_timeout():
	$FSM.set_trigger("finished_walking")


func _on_DamageArea_body_entered(body):
	if not body is Player:
		return
	
	var player = body as Player
	player.get_health().take_damage(10)
	
func save(save: GameData):
	save.game_data['simpleEnemy'] = position

func load(save: GameData):
	position = save.game_data['simpleEnemy']
