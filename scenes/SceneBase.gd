extends Node2D

signal remove_scene
const FADE_DURATION = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_base_nodes():
	return[self]
	
func get_base_controls():
	return[$CanvasLayer/Control]
	
var scenes = []

func add_child_scene(p_scene, delay, duration):
	print("adding child scene")
	scenes.append(p_scene)
	p_scene.set_alpha(0.0)
	add_child(p_scene)
	p_scene.fade(1.0, delay, duration)
	
#func remove_current_child_scene():
#	var scene = scenes.pop_back()
#	remove_child(scene)
	
func fade(to_alpha, delay, duration):
	var tween = create_tween()
#	tween.tween_interval(0.1)
	tween.tween_interval(delay)
	for node in get_base_nodes():
		tween.chain().tween_property(node, "modulate:a", to_alpha, duration)
	for control in get_base_controls():
		tween.parallel().tween_property(control, "modulate:a", to_alpha, duration)

func fade_out_and_remove(delay, duration):
	fade(0.0, delay, duration)
	var tween = create_tween()
	tween.tween_interval(delay + duration)
	tween.chain().tween_callback(self, "queue_free")
	
func remove_child_and_fade_in(p_child):
	p_child.fade_out_and_remove(0.0, 0.5)
	fade(1.0, 0.5, 0.5)
	
	
func set_alpha(to_alpha):
	for node in get_base_nodes():
		node.modulate.a = to_alpha
	for control in get_base_controls():
		control.modulate.a = to_alpha

func show_alert(p_title, p_message):
	var alert_scene = load("res://scenes/AlertScene.tscn").instance()
	add_child_scene(alert_scene, 0.0, FADE_DURATION)
	alert_scene.setup(p_title, p_message)
	
	
func show_toast(p_message):
	pass

