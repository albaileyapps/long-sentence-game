extends Control

var teams: Teams
var team_label = preload("res://components/ScoreboardListItem.tscn")
var selected_team
onready var team_labels_vbox = $TeamLabelsVBox

const SCOREBOARD_ITEM_GROUP = "scoreboard_item_group"



#call this before adding to scene
func setup(p_teams):
	teams = p_teams
	build_team_list()

func build_team_list():
	remove_list_items()
	for team in teams.list:
		var label = team_label.instance()
		label.setup(team)
		label.add_to_group(SCOREBOARD_ITEM_GROUP)
		label.connect("team_pressed", self, "on_team_pressed")
		team_labels_vbox.add_child(label)
		
func remove_list_items():
	for n in team_labels_vbox.get_children():
		n.queue_free()

func on_team_pressed(p_team):
	var original_val = p_team.is_selected
	var team_labels = get_tree().get_nodes_in_group(SCOREBOARD_ITEM_GROUP)
	for label in team_labels:
		label.is_selected = false
	p_team.is_selected = !original_val
	
func select_none():
	var team_labels = get_tree().get_nodes_in_group(SCOREBOARD_ITEM_GROUP)
	for label in team_labels:
		label.is_selected = false
