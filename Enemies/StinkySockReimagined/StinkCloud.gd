extends Area2D

var player: Player
export var stink_damage := 10
export var stink_damage_interval := 1.0

func expand():
	$AnimationPlayer.play("StinkExpansion")


func _on_StinkCloud_body_entered(body):
	if body is Player:
		player = body as Player
		$StinkTimer.stop()
		$StinkTimer.start(stink_damage_interval)

func _on_StinkCloud_body_exited(body):
	if body is Player:
		player = null


func _on_StinkTimer_timeout():
	if player != null:
		player.get_health().take_damage(stink_damage)


