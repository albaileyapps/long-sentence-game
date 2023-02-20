extends "res://scenes/SceneBase.gd"

var tasks
var task_list_item = preload("res://components/EditTasksListItem.tscn")
var edit_task_scene = preload("res://scenes/EditTask.tscn")

var rng = RandomNumberGenerator.new()

func setup(p_tasks):
	tasks = p_tasks

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	tasks.connect("changed", self, "on_tasks_changed")
	build_list()

func build_list():
	for task in tasks.list:
		add_list_item(task)
	
func remove_list_items():
	var children = get_node("%TasksList").get_children()
	for child in children:
		child.queue_free()
		
func add_list_item(p_task):
	var list_item = task_list_item.instance()
	get_node("%TasksList").add_child(list_item)
	list_item.setup(p_task)
	list_item.connect("edit_task_pressed", self, "edit_task", [p_task, 0.0])
	
func remove_task():
	pass
	
func on_tasks_changed():
	remove_list_items()
	build_list()
#	tasks.save()


func _on_AddTaskButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	var id = str(rng.randi_range(0, 10000000))
	var task = Task.new(id, "Title", "Description", [], false, false, OS.get_system_time_msecs())
	tasks.add_task(task)
	edit_task(task, 0.2)

	
func edit_task(p_task, p_delay):
	var scene = edit_task_scene.instance()
	scene.connect("delete_task", self, "_on_delete_task")
#	scene.connect("remove_scene", self, "build_list")
	add_child_scene(scene, p_delay, FADE_DURATION)
	scene.setup(p_task)
	
func _on_delete_task(p_task):
	print("delete task: ", p_task)
	tasks.remove_task(p_task)

func _on_SelectNoneButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	for task in tasks.list:
		task.is_selected = false
		
func _on_ExitButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	emit_signal("remove_scene")
