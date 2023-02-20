extends Resource
class_name TimerSettings

export var minutes: int = 5 setget _set_minutes
export var seconds: int = 0 setget _set_seconds

func _set_minutes(p_val):
	minutes = p_val
	emit_changed()

func _set_seconds(p_val):
	seconds = p_val
	emit_changed()
	
func save():
	print("saving timer settings")
	var error = ResourceSaver.save(Consts.TIMER_SAVE_FILE, self)
	print(error)
	
		
