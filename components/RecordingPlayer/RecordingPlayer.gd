extends AudioStreamPlayer2D

func play_segment(from: float, duration: float):
	play(from)
	$Timer.start(duration)

func _on_Timer_timeout():
	stop()
