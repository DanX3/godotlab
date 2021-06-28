extends Node

var weapon : Weapon

func _ready():
	pass

func set_weapon(weapon: Weapon):
	self.weapon = weapon

func attack(state: String):
	if weapon != null:
		weapon
