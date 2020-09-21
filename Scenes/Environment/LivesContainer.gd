extends HBoxContainer

func update_lives(lives):
	print("UPDATE LIVES")
	for child in get_children():
		child.queue_free()
	for i in range(lives):
		var life = preload("res://Scenes/Environment/Heart.tscn")
		var lifeInstance = life.instance();
		add_child(lifeInstance)
	
