extends Node

class_name Weapon

export var attack_duration := 1.0

func _ready():
	$EndAttack.wait_time = attack_duration

func attack():
	print('attacked')
	$Shape.disabled = false
	$EndAttack.start()

func _on_EndAttack_timeout():
	print("end attack")
	$Shape.disabled = true
