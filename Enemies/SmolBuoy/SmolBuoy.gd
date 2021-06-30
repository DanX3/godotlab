extends Enemy

export var move_speed := 15.0
export var walk_duration := 3.0
export var pause_duration := 1.0
export var charge_distace := 40
export var attack_distance := 40
var walking_dir := Vector2.LEFT

func _ready():
	_flip_x()
	$FSM.set_trigger("start")
	
func _flip_x():
	if (walking_dir.x > 0) != ($Sprites.scale.x > 0):
		$Sprites.scale.x *= -1
		$Sight/SightLine.rotation_degrees = fmod($Sight/SightLine.rotation_degrees + 180.0, 360)
		print("flip x")

func _on_WalkTimer_timeout():
	$FSM.set_trigger("finished_walking")


func _on_RestTimer_timeout():
	print("Finished resting")
	$FSM.set_trigger("finished_resting")


func _on_FSM_updated(state, delta):
	if state == "Entry":
		$FSM.set_trigger("start")
		return
		
	match state:
		"Resting":
			pass
		"Wandering":
			move_and_slide(move_speed * walking_dir)
		"SeenPlayer":
			walking_dir = Vector2(sign(player.position.x - position.x), 0)
			move_and_slide(move_speed * walking_dir)
			_flip_x()
#		ATTACKING:
#			pass

func _on_FSM_transited(from, to):
#	print(from + " => " + to)
	$Label.text = to
	match to:
		"Resting":
			if $AnimationPlayer.current_animation != "Walk":
				$AnimationPlayer.play("Walk")
			$RestTimer.wait_time = pause_duration
			$RestTimer.start()
		"Wandering":
			$WalkTimer.wait_time = walk_duration
			if $AnimationPlayer.current_animation != "Walk":
				$AnimationPlayer.play("Walk")
			$WalkTimer.start()
			if randf() < 0.5:
				walking_dir.x *= -1
				_flip_x()
		"Attacking":
			$AnimationPlayer.play("Attack")


func _on_Sight_body_entered(body):
	if not body is Player:
		return
		
	player = body as Player
	$FSM.set_trigger("attack")
	
func go_back():
	$Sight/SightLine.disabled = true
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
	$Sight/SightLine.disabled = false
	$FSM.set_trigger("finished_attacking")
