extends Node2D

onready var timer = $SpawnTimer
onready var game_gui = $GUI
#onready var death_gui = $DeathGUI/DeathGUI

var can_spawn = true
var rightSpawnPoint = Vector2(2200,-75)
var leftSpawnPoint = Vector2(-2200,-70)
var spawn_points = [rightSpawnPoint, leftSpawnPoint]
var number_of_enemies = 0 
var max_number_of_enemies_in_screen = 3

signal update_lives

func _ready():
	show_game_gui()
	get_tree().call_group("NumberOfKills", "reset_kills")
	timer.start()
	if (not BackgroundMusic.playing):
		BackgroundMusic.set_pitch(false)
		BackgroundMusic.play_game_music()

func _process(delta):
	if(get_number_of_enemies() < max_number_of_enemies_in_screen and can_spawn):
		generate_enemies()

func get_number_of_enemies():
	return get_node("Enemies").get_child_count();

func generate_enemies():
	can_spawn = false
	var enemy = preload("res://Scenes/Player/Enemy.tscn")
	var enemyInstance = enemy.instance();
	enemyInstance.position = get_spawn_point()
	if(number_of_enemies > 0 and number_of_enemies % 5 == 0):
		enemyInstance.init_boss()
		update_max_number_of_enemies_in_screen()
	get_node("Enemies").add_child(enemyInstance)
	number_of_enemies = number_of_enemies + 1

func get_spawn_point():
	return spawn_points[randi() % spawn_points.size()]

func _on_Timer_timeout():
	timer.start()
	can_spawn = true
	
func playerDied():
	show_death_gui()

func updateLives(lives):
	get_tree().call_group("LivesContainer", "update_lives", lives)

func updateKills():
	get_tree().call_group("NumberOfKills", "updateKills")

func update_max_number_of_enemies_in_screen():
	max_number_of_enemies_in_screen = max_number_of_enemies_in_screen + 2

func show_death_gui():
	for i in range(0, $GUI.get_child_count()):
		$GUI.get_child(i).queue_free()
	var death_gui = preload("res://Scenes/Environment/DeathGUI.tscn")
	$GUI.add_child(death_gui.instance())

func show_game_gui():
	for i in range(0, $GUI.get_child_count()):
		$GUI.get_child(i).queue_free()
	var gui = preload("res://Scenes/Environment/GUI.tscn")
	$GUI.add_child(gui.instance())
	
func restart():
	get_tree().reload_current_scene()

