extends Control

var task
var checked_texture = preload("res://assets/img/icon-checked.png")
var unchecked_texture = preload("res://assets/img/icon-unchecked.png")
onready var check_mark = $HBoxContainer/VBoxContainer3/CheckMark

var is_pressed = false
var touch_down_time = 0
var touch_down_pos = Vector2(0,0)

const color_selected = Color(1.0, 1.0, 1.0, 1.0)
const color_selected_hover = Color(1.0, 1.0, 1.0, 0.85)
const color_deselected = Color(0.9, 0.9, 0.9, 0.7)
const color_deselected_hover = Color(0.9, 0.9, 0.9, 0.8)


signal edit_task_pressed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setup(p_task):
	task = p_task
	task.connect("changed", self, "_on_task_changed")
	set_item_children()
	
func set_item_children():
	get_node("%TitleLabel").text = task.title
	get_node("%DescriptionLabel").text = task.description
	if task.is_selected:
		var col = color_selected_hover if get_rect().has_point(get_global_mouse_position()) else color_selected
		material.set_shader_param("panel_color", col)
		modulate.a = 1.0
		check_mark.texture = checked_texture
	else:
		var col = color_deselected_hover if get_rect().has_point(get_global_mouse_position()) else color_deselected
		material.set_shader_param("panel_color", color_deselected_hover)
		check_mark.texture = unchecked_texture
	
func _on_task_changed():
	set_item_children()
	
	
func _on_EditButton_pressed():
	emit_signal("edit_task_pressed")


func _on_EditTasksListItem_gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		touch_down_time = OS.get_system_time_msecs()
		touch_down_pos = get_local_mouse_position()
	if event is InputEventScreenTouch and !event.pressed:
		if get_local_mouse_position().distance_to(touch_down_pos) > 10:
			return
		if OS.get_system_time_msecs() - touch_down_time > 500:
			return
		SoundManager.play(SoundManager.CLICK)
		task.is_selected = !task.is_selected



func _on_EditTasksListItem_mouse_entered():
	if task.is_selected: material.set_shader_param("panel_color", color_selected_hover)
	else: material.set_shader_param("panel_color", color_deselected_hover)

func _on_EditTasksListItem_mouse_exited():
	if task.is_selected: material.set_shader_param("panel_color", color_selected)
	else: material.set_shader_param("panel_color", color_deselected)
