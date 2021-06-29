extends Node

class_name Weapon

export var attack_duration := 1.0
export var damage := 10

func attack():
	print('attacked')
	
	$Shape.disabled = false

func end_attack():
	print("end attack")
	$Shape.disabled = true
