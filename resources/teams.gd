extends Resource
class_name Teams

class CustomSorterTeam:
	static func sort(a: Team, b: Team):
		if a.date_created > b.date_created:
			return true
		return false

export(Array, Resource) var list = [Team.new("0001", "Team 1", 0, 0), Team.new("0002", "Team 2", 0, 0)]

# Called when the node enters the scene tree for the first time.
func _init():
	pass
	
func setup():
	for team in list:
		print("connecting team signal")
		team.connect("changed", self, "emit_changed")
	list.sort_custom(CustomSorterTeam, "sort")
	

func add_team(p_team):
	list.push_front(p_team)
	p_team.connect("changed", self, "emit_changed")
	emit_changed()
	
func remove_team(p_team):
	list.erase(p_team)
	emit_changed()
	
