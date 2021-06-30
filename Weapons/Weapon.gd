extends Node

class_name Weapon

export var attack_duration := 1.0
export var damage := 10
var player : Player

func _ready():
	player = (get_tree().get_nodes_in_group("player")[0]) as Player


