extends Label

var kills

func _ready():
	kills = str(Global.kills)
	text = kills
	
func updateKills():
	kills = int(text)
	Global.kills = kills + 1
	text = str(Global.kills)

func resetKills():
	text = str(0)
