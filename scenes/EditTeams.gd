extends "res://scenes/SceneBase.gd"

var teams: Teams
var team_list_item = preload("res://components/EditTeamsListItem.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	build_list()
	teams.connect("changed", self, "on_teams_changed")
	
func setup(p_teams):
	teams = p_teams
	
func build_list():
	for team in teams.list:
		add_list_item(team)
	
func remove_list_items():
	var children = get_node("%TeamList").get_children()
	for child in children:
		child.queue_free()
		
func add_list_item(p_team):
	var list_item = team_list_item.instance()
	list_item.setup(p_team)
	list_item.connect("remove_team", self, "remove_team")
	get_node("%TeamList").add_child(list_item)
	
func on_teams_changed():
	pass
	
func rebuild_list():
	remove_list_items()
	build_list()


func _on_AddTeamButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	var id = String(rng.randi_range(0, 10000000))
	var team = Team.new(id, "New Team", 0)
	teams.add_team(team)
	rebuild_list()
	
func remove_team(p_team):
	teams.remove_team(p_team)
	rebuild_list()

func _on_ResetScoresButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	for team in teams.list:
		team.score = 0

func _on_ExitButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	emit_signal("remove_scene")

