extends Control

var settings = preload("res://resources/timer_settings_default.tres")
var current_minutes = 0
var current_seconds = 0

enum TimerState {RUNNING, PAUSED, STOPPED}
var current_state = TimerState.STOPPED

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	_set_labels()


func load_settings():
	var dir = Directory.new()
	if dir.file_exists(Consts.TIMER_SAVE_FILE):
		settings = ResourceLoader.load(Consts.TIMER_SAVE_FILE)
		current_minutes = settings.minutes
		current_seconds = settings.seconds

func _on_MinutesLineEdit_text_changed(new_text):
	$Timer.stop()
	if new_text.is_valid_integer():
		current_minutes = clamp(int(new_text), 0, 99)
	else:
		current_minutes = 0
	settings.minutes = current_minutes
	settings.save()

func _on_SecondsLineEdit_text_changed(new_text):
	$Timer.stop()
	if new_text.is_valid_integer():
		current_seconds = clamp(int(new_text), 0, 59)
	else:
		current_seconds = 0
	settings.seconds = current_seconds
	settings.save()
	
func _set_labels():
#	if !get_node("%MinutesLineEdit").has_focus():
	get_node("%MinutesLineEdit").text = String(current_minutes).pad_zeros(2)
	
	get_node("%SecondsLineEdit").text = String(current_seconds).pad_zeros(2)

func _on_MinutesLineEdit_focus_exited():
	_set_labels()

func _on_SecondsLineEdit_focus_exited():
	_set_labels()


func reset_timer():
	current_minutes = settings.minutes
	current_seconds = settings.seconds
	_set_labels()

func _on_Timer_timeout():
	decrement()
	
func decrement():
	current_seconds -= 1
	if current_minutes == 0 and 3 < current_seconds and current_seconds <= 10:
		SoundManager.play(SoundManager.TICK)
	if current_minutes == 0 and 0 < current_seconds and current_seconds <= 3:
		SoundManager.play(SoundManager.BEEP)
	if current_seconds == 0 and current_minutes == 0:
		SoundManager.play(SoundManager.GONG)
		$Timer.stop()
	if current_seconds < 0:
		current_minutes -= 1
		current_seconds = 59
	_set_labels()

func _on_StartButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	if $Timer.is_stopped():
		$Timer.start()

func _on_PauseButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	$Timer.stop()

func _on_StopButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	$Timer.stop()
	current_minutes = settings.minutes
	current_seconds = settings.seconds
	_set_labels()
