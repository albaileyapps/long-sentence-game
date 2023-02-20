extends "res://scenes/SceneBase.gd"


# Called when the node enters the scene tree for the first time.
func _ready():

	#this is the dir where user created tasks are stored, create it if it doesn't exist
	var dir = Directory.new()
	if !dir.dir_exists(Consts.SESSION_SAVE_DIR):
		dir.make_dir(Consts.SESSION_SAVE_DIR)
		
#	currently the main menu scene is never removed - just hidden and shown
	var main_menu = load("res://scenes/MainMenu.tscn").instance()
	add_child_scene(main_menu, 0.0, 0.5)
