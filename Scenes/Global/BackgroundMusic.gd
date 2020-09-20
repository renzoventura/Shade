extends AudioStreamPlayer

const game_music = "res://Assets/Soundtrack/background.ogg"

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
