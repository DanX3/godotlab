extends ProgressBar


func _ready():
	var nodes = get_tree().get_nodes_in_group("player")
	if (len(nodes) != 1):
		return
	
	var score = (nodes[0] as Player).get_score()
	score.connect("score_changed", self, "_on_score_changed")

func _on_score_changed(new_score):
	value = new_score

