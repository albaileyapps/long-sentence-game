extends Node

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func id():
	var now = String(OS.get_system_time_msecs())
	return now + "-" + String(rng.randi_range(0, 1000000))
