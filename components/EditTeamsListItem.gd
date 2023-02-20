extends HBoxContainer

var team
signal remove_team

func setup(p_team):
	team = p_team
	set_text()
	team.connect("changed", self, "on_team_changed")

func set_text():
#	currently, the change signal from the Team causes a re-set of the text
# 	but setting the text whilst typing causes weird things to happen - so don't set text if it has focus - wonky workaround!!
	if !get_node("%TeamNameTextEdit").has_focus():
		get_node("%TeamNameTextEdit").text = team.team_name
	if !get_node("%TeamScoreTextEdit").has_focus():
		get_node("%TeamScoreTextEdit").text = String(team.score)
	
func _on_TeamNameTextEdit_text_changed(p_text):
	team.team_name = p_text

func _on_TeamScoreTextEdit_text_changed(p_text):
	print(p_text)
	team.score = int(p_text)

func _on_RemoveButton_pressed():
	SoundManager.play(SoundManager.CLICK)
	emit_signal("remove_team", team)
	
func on_team_changed():
	set_text()
	

