extends Resource
class_name Session

export var id: String = ""
export var title: String = ""
export var last_saved: int = 0
export(Resource) var tasks
export(Resource) var teams

func _init(p_id = "", p_title = "", p_last_saved = 0, p_tasks: Tasks = null, p_teams: Teams = null):
	id = p_id
	title = p_title
	last_saved = p_last_saved
	tasks = p_tasks
	teams = p_teams
	
	
func setup():
	print("session setup")
	tasks.setup()
	teams.setup()
	tasks.connect("changed", self, "save")
	teams.connect("changed", self, "save")

func save():
	print("saving session")
	last_saved = OS.get_system_time_msecs()
	var error = ResourceSaver.save(Consts.SESSION_SAVE_FILE % id, self)


