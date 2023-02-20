extends "res://scenes/SceneBase.gd"

onready var session_title_line_edit = $CanvasLayer/Control/VBoxContainer/SessionTitleLineEdit

signal start_session(p_title)
signal cancel_session_setup


func _on_StartButton_pressed():
	var title = session_title_line_edit.text
	if title.length() > 0:
		fade_out_and_remove(0.0, FADE_DURATION)
		SoundManager.play(SoundManager.CLICK)
		emit_signal("start_session", title)
		

func _on_CancelButton_pressed():
	fade_out_and_remove(0.0, FADE_DURATION)
	SoundManager.play(SoundManager.CLICK)
	emit_signal("cancel_session_setup")
