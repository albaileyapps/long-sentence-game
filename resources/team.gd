extends Resource
class_name Team

export var id: String = ""
export var team_name: String = "" setget set_team_name, get_team_name
export var score: int = 0 setget set_score, get_score
export var date_created: int = 0 setget _set_date_created

#overriding _init must have default values set for all args for ResourceSaver/Loader to work properly
func _init(p_id = "", p_name = "", p_score = 0, p_date_created = 0):
	id = p_id
	team_name = p_name
	score = p_score
	date_created = p_date_created

func set_team_name(p_val):
	team_name = p_val
	emit_changed()

func get_team_name():
	return team_name
	
func set_score(p_val):
	score = p_val
	emit_changed()
	
func get_score():
	return score

func _set_date_created(p_date):
	date_created = p_date
	
