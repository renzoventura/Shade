extends Node2D



onready var timer = $SpawnTimer
var can_spawn = true
var rightSpawnPoint = Vector2(2021.296,-76.711)
var leftSpawnPoint = Vector2(-2241.207,-68.302)
var spawn_points = [rightSpawnPoint, leftSpawnPoint]

func _ready():
	timer.start()

func _process(delta):
	generate_enemies()

func get_number_of_enemies():
	return get_node("Enemies").get_child_count();

func generate_enemies():
	if(get_number_of_enemies() < 1 or can_spawn):
		can_spawn = false
		var enemy = preload("res://Scenes/Player/Enemy.tscn")
		var enemyInstance = enemy.instance();
		enemyInstance.position = get_spawn_point()
		get_node("Enemies").add_child(enemyInstance)

func get_spawn_point():
	return spawn_points[randi() % spawn_points.size()]

func _on_Timer_timeout():
	timer.start()
	can_spawn = false
	
func playerDied():
	print("DEAD!")
