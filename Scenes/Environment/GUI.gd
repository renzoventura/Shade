extends CanvasLayer

onready var livesContainer = $Control/VBoxContainer/LivesContainer

func hide_gui():
	print("hiding game")
	$Control.visible = false
	
func show_gui():
	print("showing game")
	$Control.visible = true

func _on_TemplateLevel_update_lives(lives):
	print("test: " + str(lives))
	for child in livesContainer.get_children():
		child.queue_free()
	for i in range(lives):
		var life = preload("res://Scenes/Environment/Heart.tscn")
		var lifeInstance = life.instance();
		print("instance")
		livesContainer.add_child(lifeInstance)
