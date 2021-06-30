extends "res://components/FSM.gd"

export var move_speed := 15.0
export var walk_duration := 3.0
export var pause_duration := 1.0
export var charge_distace := 40
export var attack_distance := 40
var walking_dir := Vector2.LEFT

func _ready():
	add_state("rest")
	add_state("walk")
	add_state("seen_player")
	add_state("attack")
	call_deferred("set_state", "rest")

func _flip_x():
	if (walking_dir.x > 0) != ($Sprites.scale.x > 0):
		$Sprites.scale.x *= -1
		$Sight/SightLine.rotation_degrees = fmod($Sight/SightLine.rotation_degrees + 180.0, 360)

func _enter_state(new_state, old_state):
	$Label.text = new_state
	match new_state:
		states.rest:
			if $AnimationPlayer.current_animation != "Walk":
				$AnimationPlayer.play("Walk")
			$RestTimer.wait_time = pause_duration
			$RestTimer.start()
		states.walk:
			$WalkTimer.wait_time = walk_duration
			if $AnimationPlayer.current_animation != "Walk":
				$AnimationPlayer.play("Walk")
			$WalkTimer.start()
			if randf() < 0.5:
				walking_dir.x *= -1
				_flip_x()
		states.seen_player:
			$AnimationPlayer.play("Attack")

func _exit_state(old_state, new_state):
	pass

func _state_process(delta):
	if state == "Entry":
		$FSM.set_trigger("start")
		return
		
	match state:
		states.rest:
			pass
		states.walk:
			$"../".move_and_slide()
			get_parent().move_and_slide(move_speed * walking_dir)
		states.seen_player:
			var player = get_parent().player as Player
			walking_dir = Vector2(sign(player.position.x - get_parent().position.x), 0)
			get_parent().move_and_slide(move_speed * walking_dir)
			_flip_x()
	
func _get_transition(delta):
	return null
