extends Control

export var color_selected = Color(1.0, 0.82, 0.23, 1.0)
export var color_selected_hover = Color(1.0, 0.88, 0.30, 1.0)
export var color_deselected = Color(1.0, 1.0, 1.0, 1.0)
export var color_deselected_hover = Color(1.0, 1.0, 1.0, 0.9)

var team: Team

var is_pressed = false
var touch_down_time = 0
var touch_down_pos = Vector2(0,0)

var is_selected = false setget set_is_selected

#the score label is updated by 1/-1 on a timer - this is the total amount to change it
var score_delta = 0 setget set_score_delta

signal team_pressed(p_team)

func setup(p_team: Team):
	team = p_team

func _ready():
	team.connect("changed", self, "on_team_changed")
	set_labels()
	
func set_labels():
	get_node("%TeamNameLabel").text = team.team_name
	get_node("%ScoreLabel").text = String(team.score)
	
func set_text_size():
	pass
	
func on_team_changed():
	set_labels()

func set_is_selected(p_val):
	is_selected = p_val
	_set_panel_color()
		

func set_score_delta(p_val):
	score_delta = p_val
	$ScoreChangeTimer.start()
	
func _unhandled_key_input(event):
	if !is_selected: return
	if event.is_pressed(): return
	var text = event.as_text()
	var last_char = text.substr(text.length() - 1, text.length())
	if last_char.is_valid_integer():
		set_score_delta(score_delta + int(last_char))
	if event.is_action_released("ui_up"):
		SoundManager.play(SoundManager.SCORE)
		team.score += 1
	if event.is_action_released("ui_down"):
		SoundManager.play(SoundManager.SCORE)
		team.score -= 1
	
		
func _on_ScoreChangeTimer_timeout():
	SoundManager.play(SoundManager.SCORE)
	team.score += sign(score_delta)
	score_delta += sign(-score_delta)
	if score_delta == 0:
		$ScoreChangeTimer.stop()

func _on_ScoreboardListItem_mouse_entered():
	_set_panel_color()

func _on_ScoreboardListItem_mouse_exited():
	_set_panel_color()
	
func _set_panel_color():
	var hovered = get_global_rect().has_point(get_global_mouse_position())
	if is_selected:
		var col = color_selected_hover if hovered else color_selected
		material.set_shader_param("panel_color", col)
	else:
		var col = color_deselected_hover if hovered else color_deselected
		material.set_shader_param("panel_color", col)
	

func _on_ScoreboardListItem_gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		touch_down_time = OS.get_system_time_msecs()
		touch_down_pos = get_local_mouse_position()
	if event is InputEventScreenTouch and !event.pressed:
		if get_local_mouse_position().distance_to(touch_down_pos) > 10:
			return
		if OS.get_system_time_msecs() - touch_down_time > 500:
			return
		SoundManager.play(SoundManager.CLICK)
		emit_signal("team_pressed", self)
