extends Label

func updateKills():
	var kills = int(text)
	kills = kills + 1
	text = str(kills)

func resetKills():
	text = str(0)
