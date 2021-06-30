extends Node2D

export (PackedScene) var spawnable
export var spawn_interval := 5.0

onready var interval_left = spawn_interval

func _process(delta):
	interval_left -= delta
	if interval_left <= 0.0:
		interval_left += spawn_interval
		add_child(spawnable.instance())
