extends Control

class_name UI

func _ready():
	pass
	
func set_health(value):
	$VBox/Health.value = value

func set_score(value):
	$VBox/Score.value = value

func set_max_health(value):
	print("Set max health to "+ str(value))
	$VBox/Health.max_value = value
