extends Resource
class_name Tasks

class CustomSorterTask:
	static func sort(a: Task, b: Task):
		if a.date_created > b.date_created:
			return true
		return false

export var list = []

# Called when the node enters the scene tree for the first time.
func _init():
	list.sort_custom(CustomSorterTask, "sort")
	
func setup():
	for task in list:
		task.connect("changed", self, "emit_changed")
	list.sort_custom(CustomSorterTask, "sort")
	
func add_task(p_task):
	list.push_front(p_task)
	p_task.connect("changed", self, "emit_changed")
	emit_changed()
	
func remove_task(p_task):
	list.erase(p_task)
	emit_changed()
	
func duplicate_selected() -> Tasks:
	var duplicate_tasks = self.duplicate(false)
	duplicate_tasks.list = []
	for task in list:
		if task.is_selected:
			duplicate_tasks.list.append(task.duplicate())
	return duplicate_tasks
	

