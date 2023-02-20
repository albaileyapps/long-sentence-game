extends "res://scenes/SceneBase.gd"

onready var show_hide_scores_button = $CanvasLayer/Control/VBoxContainer/HBoxContainer2/ShowHideScoresButton
onready var scoreboard = $CanvasLayer/Control/VBoxContainer/HBoxContainer/Scoreboard
onready var title_label = $CanvasLayer/Control/VBoxContainer/TitleLabel
onready var task_button_scroll_container  = $CanvasLayer/Control/VBoxContainer/HBoxContainer/VBoxContainer/ScrollContainer
var session: Session

var task_button = preload("res://components/TaskButton.tscn")
var task_scene = preload("res://scenes/TaskScene.tscn")

var selected_task_button
var scoreboard_shown = true

# Called when the node enters the scene tree for the first time.
func _ready():
	print("gamescene ready")
	var selected_tasks = []
	for task in session.tasks.list:
		if task.is_selected:
			selected_tasks.append(task)
	setup_button_grid(selected_tasks)
	scoreboard.setup(session.teams)
	title_label.text = session.title
	
#call this before adding to scene
func setup(p_session):
	session = p_session

func setup_button_grid(p_selected_tasks):
	for i in p_selected_tasks.size():
		var btn = task_button.instance()
		btn.setup(p_selected_tasks[i], String(i+1))
		btn.connect("pressed", self, "_on_task_button_pressed", [btn])
		get_node("%TaskButtonGrid").add_child(btn)
		
func _on_task_button_pressed(p_btn):
	SoundManager.play(SoundManager.CLICK)
	var new_task_scene = task_scene.instance()
	new_task_scene.setup(p_btn.task)
	new_task_scene.connect("remove_scene", self, "_on_remove_task_scene", [p_btn])
#	fade(0.0, 0.0, FADE_DURATION)
	add_child_scene(new_task_scene, FADE_DURATION, FADE_DURATION)
		
func _on_remove_task_scene(p_btn):
	p_btn.task.is_completed = true
	p_btn.animate_star()
	fade(1.0, FADE_DURATION, FADE_DURATION)
	

func _on_ExitButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	SoundManager.play(SoundManager.CLICK)
	emit_signal("remove_scene")

func _on_EditTeamsButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	scoreboard.select_none()
	var scene = load("res://scenes/EditTeams.tscn").instance()
	scene.setup(session.teams)
	scene.connect("remove_scene", self, "remove_edit_scene", [scene])
	add_child_scene(scene, 0.0, FADE_DURATION)
	
func remove_edit_scene(p_scene):
	p_scene.fade_out_and_remove(0.0, FADE_DURATION)
	scoreboard.build_team_list()

func _on_ShowHideScoresButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	scoreboard_shown = !scoreboard_shown
	scoreboard.visible = scoreboard_shown
	show_hide_scores_button.text = "Hide" if scoreboard_shown else "Show"
	
func _on_HelpButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	show_alert("SCORES", "Click on a team to select it. Use the number buttons on your keyboard to assign points to the selected team.")

func save_session():
	var error = ResourceSaver.save(Consts.SESSION_SAVE_FILE % session.id, session)
	print("GameScene saving session: ", error)

func _on_ScrollContainer_resized():
	pass		

func _on_PlusButton_pressed():
	if $"%TaskButtonGrid".columns > 5: return
	$"%TaskButtonGrid".columns += 1

func _on_MinusButton_pressed():
	if $"%TaskButtonGrid".columns < 2: return
	$"%TaskButtonGrid".columns -= 1
