extends Node

const SaveGame = preload('res://Scenes/GameData.gd')
var SAVE_FOLDER : String = "res://save"
var SAVE_NAME_TEMPLATE : String = "save_%03d.tres"

func save(id: int) -> void:
	var save_game = SaveGame.new()
	save_game.version = ProjectSettings.get_setting("application/config/version")
	for node in get_tree().get_nodes_in_group('save'):
		node.save(save_game)
	
	var directory : Directory = Directory.new()
	if not directory.dir_exists(SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)
	
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	print("saving to %s" % save_path)
	print(save_game)
	var error : int = ResourceSaver.save(save_path, save_game)
	if error != OK:
		print("There was an issue writing the save %s to %s, error %d" % [id, save_path, error])
	

func _load(id: int):
	var save_file_path : String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var file : File = File.new()
	assert(file.file_exists(save_file_path))
	if not file.file_exists(save_file_path):
		print("Save file %s doesn't exists" % save_file_path)
		return
	
	var save_game : Resource = load(save_file_path)
	for node in get_tree().get_nodes_in_group('save'):
		node.load(save_game)

func _on_Button_pressed():
	save(0)


func _on_Load_pressed():
	_load(0)
