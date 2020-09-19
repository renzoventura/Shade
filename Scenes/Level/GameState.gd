extends Node2D

onready var timer = $SpawnTimer
var can_spawn = true
var rightSpawnPoint = Vector2(2200,-75)
var leftSpawnPoint = Vector2(-2200,-70)
var spawn_points = [rightSpawnPoint, leftSpawnPoint]
var number_of_enemies = 0 
var max_number_of_enemies_in_screen = 1

signal updateLivesGui
signal updateKills

func _ready():
	timer.start()

func _process(delta):
	if(get_number_of_enemies() < 2 or can_spawn):
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
	get_tree().reload_current_scene()

func updateLives(lives):
	emit_signal("updateLivesGui", lives)

func updateKills():
	emit_signal("updateKills")

func update_max_number_of_enemies_in_screen():
	max_number_of_enemies_in_screen = max_number_of_enemies_in_screen + 1
