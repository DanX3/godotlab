extends Node

class_name Score
export var score := 0
signal score_changed(new_value)


# Called when the node enters the scene tree for the first time.
var time_passed := 0.0
func _ready():
	pass # Replace with function body.

func reset():
	score = 0
	emit_signal("score_changed", score)
	
func add(amount: int):
	score += amount
	emit_signal("score_changed", score)

func _process(delta):
	time_passed += delta
	if time_passed > 1.0:
		time_passed -= 1.0
		add(3)
