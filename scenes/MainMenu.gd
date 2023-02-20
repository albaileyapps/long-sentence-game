extends "res://scenes/SceneBase.gd"

var tasks_default = preload("res://resources/tasks_defaults.tres")
onready var saved_session_list = $CanvasLayer/Control/VBoxContainer/ScrollContainer/SavedSessionList
var saved_session_list_item = preload("res://components/SavedSessionListItem.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_saved_defaults()
	tasks_default.setup()
	tasks_default.connect("changed", self, "_on_tasks_default_changed")
	load_saved_sessions()
	
func _on_tasks_default_changed():
	var error = ResourceSaver.save(Consts.TASKS_SAVED_DEFAULTS, tasks_default)
	print(error)
	
func _on_EditTasksButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	var scene = load("res://scenes/EditTasks.tscn").instance()
	scene.setup(tasks_default)
	scene.connect("remove_scene", self, "remove_child_and_fade_in", [scene])
	fade(0.0, 0.0, FADE_DURATION)
	add_child_scene(scene, FADE_DURATION, FADE_DURATION)
	
func _on_StartButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	var session_setup = load("res://scenes/SessionSetup.tscn").instance()
	session_setup.connect("start_session", self, "create_session")
	session_setup.connect("cancel_session_setup", self, "_on_cancel_session_setup")
	fade(0.0, 0.0, FADE_DURATION)
	add_child_scene(session_setup, FADE_DURATION, FADE_DURATION)
		
func create_session(p_title):
	var session = Session.new(Utils.id(), p_title, 0, tasks_default.duplicate_selected(), Teams.new())
	session.setup()
	session.save()
	add_saved_session_button(session)
	start_game_scene(session)
	
func _on_cancel_session_setup():
	fade(1.0, FADE_DURATION, FADE_DURATION)
	
	
func start_game_scene(p_session):
	var scene = load("res://scenes/GameScene.tscn").instance()
	scene.setup(p_session)
	scene.connect("remove_scene", self, "remove_child_and_fade_in", [scene])
	fade(0.0, 0.0, FADE_DURATION)
	add_child_scene(scene, FADE_DURATION, FADE_DURATION)

func _on_HelpButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	var title = "How To Use"
	var message = "Before your lesson, click Edit Tasks and choose a few tasks that are suitable for your classroom. You can create your own tasks by clicking 'Add Task'. \n\nClick the start button to create a new session and give it a title (usually the class name).\n\nThen on the game scene, use the numbered buttons to choose a task and the scoreboard to assign points (use the number keys on your keyboard). Sessions are saved automatically, so you can play over several lessons if needed."
	show_alert(title, message)

func load_saved_defaults():
	var dir = Directory.new()
	if !dir.file_exists(Consts.TASKS_SAVED_DEFAULTS): return
	var saved_tasks = ResourceLoader.load(Consts.TASKS_SAVED_DEFAULTS)
	if saved_tasks is Tasks:
		tasks_default = saved_tasks
		
func load_saved_sessions():
	var dir = Directory.new()
	if dir.open(Consts.SESSION_SAVE_DIR) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.get_extension() == "tres":
				var session = ResourceLoader.load(Consts.SESSION_SAVE_DIR + file_name)
				if session is Session:
					add_saved_session_button(session)
			file_name = dir.get_next()

	
func add_saved_session_button(p_session: Session):
	var btn = saved_session_list_item.instance()
	btn.setup(p_session.id, p_session.title)
	btn.connect("session_select", self, "_on_saved_session_select")
	btn.connect("session_delete", self, "_on_saved_session_delete")
	saved_session_list.add_child(btn)
	
func _on_saved_session_select(p_id: String):
	var session = ResourceLoader.load(Consts.SESSION_SAVE_FILE % p_id)
	if session is Session:
		session.setup()
		start_game_scene(session)
		
func _on_saved_session_delete(p_btn):
	var dir = Directory.new()
	dir.remove(Consts.SESSION_SAVE_FILE % p_btn.id)
	saved_session_list.remove_child(p_btn)
	
