extends AudioStreamPlayer

const game_music = "res://Assets/Soundtrack/background.ogg"
const menu_music = "res://Assets/Soundtrack/menu.ogg"

func _ready():
	self.set_pause_mode(2) # Set pause mode to Process
	set_process(true)

func play_game_music():
	set_pitch(false)
	stream = load(game_music)
	play()

func set_pitch(paused):
	if paused:
		pitch_scale = 0.8
	else:
		pitch_scale = 1

func play_menu_music():
	set_pitch(false)
	stream = load(menu_music)
	play()
