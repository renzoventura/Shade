extends CanvasLayer

onready var livesContainer = $Control/VBoxContainer/LivesContainer
onready var kills_text = $Control/VBoxContainer/HBoxContainer2/Skull/kills
func _on_TemplateLevel_updateLivesGui(lives):
	for child in livesContainer.get_children():
		child.queue_free()
	for i in range(lives):
		var life = preload("res://Scenes/Environment/Heart.tscn")
		var lifeInstance = life.instance();
		livesContainer.add_child(lifeInstance)
	
func _on_TemplateLevel_updateKills():
	var kills = int(kills_text.text)
	kills = kills + 1
	kills_text.text = str(kills)
