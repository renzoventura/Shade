extends Control

const BLACK = Color(0,0,0)
const WHITE = Color(1,1,1)

var level_scene = "res://Scenes/Level/TemplateLevel.tscn"

onready var start_button = $VBoxContainer/Menu/VBoxContainer/START
onready var control_button = $VBoxContainer/Menu/VBoxContainer/CONTROLS
onready var credits_button = $VBoxContainer/Menu/VBoxContainer/CREDITS
onready var control_back_button = $VBoxContainer/Controls/VBoxContainer/BACK
onready var credits_back_button = $VBoxContainer/Credits/VBoxContainer/Label3
onready var menu = $VBoxContainer/Menu
onready var credits = $VBoxContainer/Credits
onready var control = $VBoxContainer/Controls



func _ready():
	BackgroundMusic.play_menu_music()
	show_menu()

func _on_START_mouse_entered():
	start_button.add_color_override("font_color", BLACK)

func _on_START_mouse_exited():
	start_button.add_color_override("font_color", WHITE)

func _on_START_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			start_button.add_color_override("font_color", WHITE)
			SfxPlayer.play_sfx()
			BackgroundMusic.set_pitch(false)
			Global.reset_kills()
			get_tree().change_scene_to(load(str(level_scene)))

func _on_CONTROLS_mouse_entered():
	control_button.add_color_override("font_color", BLACK)

func _on_CONTROLS_mouse_exited():
	control_button.add_color_override("font_color", WHITE)

func _on_CONTROLS_gui_input(event):
	if event is InputEventMouseButton:
		control_button.add_color_override("font_color", WHITE)
		if event.button_index == BUTTON_LEFT and event.pressed:
			SfxPlayer.play_sfx()
			hide_menu_credits()

func hide_menu_credits():
	menu.visible = false
	credits.visible = false
	control.visible = true
	
func show_menu():
	menu.visible = true
	credits.visible = false
	control.visible = false

func show_credits():
	menu.visible = false
	credits.visible = true
	control.visible = false
	
func _on_BACK_mouse_entered():
	control_back_button.add_color_override("font_color", BLACK)

func _on_BACK_mouse_exited():
	control_back_button.add_color_override("font_color", WHITE)

func _on_BACK_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			control_back_button.add_color_override("font_color", WHITE)
			SfxPlayer.play_sfx()
			show_menu()


func _on_CREDITS_mouse_entered():
	credits_button.add_color_override("font_color", BLACK)


func _on_CREDITS_mouse_exited():
	credits_button.add_color_override("font_color", WHITE)


func _on_CREDITS_gui_input(event):
	if event is InputEventMouseButton:
		credits_button.add_color_override("font_color", WHITE)
		if event.button_index == BUTTON_LEFT and event.pressed:
			SfxPlayer.play_sfx()
			show_credits()





func _on_Label3_mouse_entered():
	credits_back_button.add_color_override("font_color", BLACK)


func _on_Label3_mouse_exited():
	credits_back_button.add_color_override("font_color", WHITE)


func _on_Label3_gui_input(event):
	if event is InputEventMouseButton:
		credits_back_button.add_color_override("font_color", WHITE)
		if event.button_index == BUTTON_LEFT and event.pressed:
			SfxPlayer.play_sfx()
			show_menu()

