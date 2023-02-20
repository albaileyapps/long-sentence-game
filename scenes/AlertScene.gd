extends "res://scenes/SceneBase.gd"

onready var title = $CanvasLayer/Control/VBoxContainer/TitleLabel
onready var message = $CanvasLayer/Control/VBoxContainer/ScrollContainer/MessageLabel

var is_pressed = false
var touch_down_time = 0
var touch_down_pos = Vector2(0,0)

func setup(p_title, p_message):
	title.text = p_title
	message.text = p_message
	
func _on_ExitButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	fade_out_and_remove(0.0, FADE_DURATION)

#click anywhere to remove this alert scene
func _on_Control_gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		touch_down_time = OS.get_system_time_msecs()
		touch_down_pos = get_local_mouse_position()
	if event is InputEventScreenTouch and !event.pressed:
		if get_local_mouse_position().distance_to(touch_down_pos) > 10:
			return
		if OS.get_system_time_msecs() - touch_down_time > 500:
			return
		SoundManager.play(SoundManager.CLICK)
		fade_out_and_remove(0.0, FADE_DURATION)
