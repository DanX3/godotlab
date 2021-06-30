extends Node

export var fsm_path: NodePath
export var animator_path: NodePath

var fsm
var animator
var takes_input := true
var label
var input_reenable := 1.0
var stop_attack := 1.5

func _ready():
	fsm = get_node("../AttackFSM") as StateMachinePlayer
	animator = get_node(animator_path) as AnimationPlayer
	label = get_node("../Label") as Label
	$StopsAttacks.wait_time = 1.5
	$ReEnablesInput.wait_time = 1.0

func _input(event):
	if not takes_input:
		return
		
	if fsm.current == "Entry":
		fsm.set_trigger("start")
		
	label.text = ''
	
	if Input.is_action_just_pressed("attack_1"):
		if fsm.current.find("Final") != -1:
			return
		fsm.set_trigger("attack")
#		label.text = fsm.current
		takes_input = false
		$ReEnablesInput.start()
		$StopsAttacks.start()


func _on_ReEnablesInput_timeout():
	takes_input = true


func _on_StopsAttacks_timeout():
	fsm.set_trigger("stop")
	label.text = "stopped"
	print("stopped")
