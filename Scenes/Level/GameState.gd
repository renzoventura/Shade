extends Node2D

func _ready():
	pass

func _process(delta):
	generate_enemies()

var rightSpawnPoint = Vector2(2021.296,-76.711)
var leftSpawnPoint = Vector2(-2250.726,-68.302)
var spawn_points = [rightSpawnPoint, leftSpawnPoint]
func get_number_off_enemies():
	return get_node("Enemies").get_child_count();

func generate_enemies():
	if(get_number_off_enemies() < 1):
		var enemy = preload("res://Scenes/Player/Enemy.tscn")
		var enemyInstance = enemy.instance();
		enemyInstance.position = get_spawn_point()
		get_node("Enemies").add_child(enemyInstance)

func get_spawn_point():
	return spawn_points[randi() % spawn_points.size()]
