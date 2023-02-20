extends Button

var idx: String
var task: Task

# Called when the node enters the scene tree for the first time.
func _ready():
	print("task button: window size = ", OS.window_size)
	set_completed(task.is_completed)
	
func setup(p_task: Task, p_idx: String):
	task = p_task
	idx = p_idx

func animate_star():
	text = ""
	var tween = create_tween()
	tween.parallel().tween_property($Star.get_material(), "shader_param/amount", 2*PI, 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property($Star, "modulate:a", 1.0, 0.2)
	
func set_completed(p_val: bool):
	$Star.modulate.a = 1.0 if p_val else 0.0
	text = "" if p_val else idx
	

