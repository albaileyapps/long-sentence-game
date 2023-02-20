extends Resource
class_name Task

export var id: String = ""
export var title: String = "" setget _set_title
export var description: String setget _set_description
export var tags = [] setget _set_tags
export var is_selected = false setget _set_is_selected
export var is_completed = false setget _set_is_completed
export var date_created: int = 0 setget _set_date_created

#overriding _init must have default values set for all args for ResourceSaver/Loader to work properly
func _init(p_id = "", p_title = "", p_description = "", p_tags = [], p_is_selected = false, p_is_completed = false, p_date_created = 0):
	id = p_id
	title = p_title
	description = p_description
	tags = p_tags
	is_selected = p_is_selected
	is_completed = p_is_completed
	date_created = p_date_created

func _set_title(p_title):
	title = p_title
	emit_changed()

func _set_description(p_desc):
	description = p_desc
	emit_changed()

func _set_tags(p_tags):
	tags = p_tags
	emit_changed()

func _set_is_selected(p_val):
	is_selected = p_val
	emit_changed()
	
func _set_is_completed(p_val):
	print("task is completed")
	is_completed = p_val
	emit_changed()

func add_tag(p_tag):
	tags.append(p_tag)
	emit_changed()
	
func _set_date_created(p_date):
	date_created = p_date
	

	
