extends Node
class_name Health
export (PackedScene) var damage_label
export (NodePath) var canvas

export var maxHealth = 100
export var health: int
export var scorePath : NodePath
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score: Score
# Called when the node enters the scene tree for the first time.
func _ready():
	health = maxHealth
	score = get_node(scorePath) as Score

func take_damage(damage: int) -> void:
	health -= damage;
	health = max(health, 0)
	var damageLabel = damage_label.instance()
	get_tree().get_nodes_in_group("Canvas")[0].add_child(damageLabel)
	damageLabel.set_damage(10, get_parent())
	score.reset()
#	(get_parent() as Player).get_score().reset()
	print("Took damage: " + str(damage))
#	add_child(damageLabel)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	get_parent().get_node("Label").text += "\nHP: " + str(health)
