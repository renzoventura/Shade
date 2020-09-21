extends CanvasLayer
onready var retry_button = $Control/CenterContainer/VBoxContainer/HBoxContainer2/Retry
onready var exit_button = $Control/CenterContainer/VBoxContainer/HBoxContainer2/Exit

const BLACK = Color(0,0,0)
const WHITE = Color(1,1,1)
func hide_gui():
	$Control.visible = false
	
func show_gui():
	$Control.visible = true


func _on_Retry_mouse_entered():
	retry_button.add_color_override("font_color", BLACK)

func _on_Retry_mouse_exited():
	retry_button.add_color_override("font_color", WHITE)

func _on_Retry_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			SfxPlayer.play_sfx()
			BackgroundMusic.set_pitch(false)
			Global.reset_kills()
			get_tree().call_group("GameState", "restart")

func _on_Exit_mouse_entered():
	exit_button.add_color_override("font_color", BLACK)

func _on_Exit_mouse_exited():
	exit_button.add_color_override("font_color", WHITE)

func _on_Exit_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			SfxPlayer.play_sfx()
			BackgroundMusic.set_pitch(false)
			Global.reset_kills()
			get_tree().call_group("GameState", "restart")
