extends KinematicBody2D

var list_of_speed = [5, 10, 15, 30]
var list_of_max_speed = [300, 500, 600, 1000]
var motion = Vector2(0,0)
var motion_up = Vector2(0,-1)
var SPEED = 5;
var MAX_SPEED = 600
var current_speed = 10;
var JUMP_SPEED = 1800;
var GRAVITY = 800;
var MAX_FALL_SPEED = 3000
var life = 3
var ACCELERATION = 5
var HURT_JUMP_SPEED = -3000
var HURT_SPEED = 400
var is_moving = true

var player
onready var timer = $Timer

func _ready():
	set_physics_process(true)
	SPEED = list_of_speed[randi() % list_of_speed.size()]
	MAX_SPEED = list_of_max_speed[randi() % list_of_max_speed.size()]

func _physics_process(delta):
	apply_gravity()
	player = get_tree().get_root().find_node("Player", true, false)
	if player != null and is_moving:
		chase_player(delta)
	animate()
	move_and_slide(motion)

func chase_player(delta):
	var direction = (player.global_position - global_position)
	var enemyDirection = 1
	if(global_position > player.global_position):
		enemyDirection = -1
	if(current_speed <= MAX_SPEED):
		current_speed += SPEED
	motion.x = current_speed * enemyDirection
	$Sprite.flip_h = global_position > player.global_position

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

func hurt(var is_facing_right):
	die()
	timer.start()
	is_moving = false
	life -= 1
	var direction = 1
	if(!is_facing_right):
		direction = -1
	motion.y = HURT_JUMP_SPEED
	motion.x = HURT_SPEED * direction
	

func apply_gravity():
	if is_on_floor() and motion.y > 0: 
		motion.y = 0
	elif is_on_ceiling():
		motion.y = 1
	else:
		if(motion.y < MAX_FALL_SPEED):
			motion.y += GRAVITY

func animate():
	if motion.x != 0:
		$Sprite/AnimationPlayer.play("Walk")
		yield(get_node("Sprite/AnimationPlayer"), "animation_finished")
		
func die():
	if(life < 0):
		queue_free()

func _on_Timer_timeout():
	is_moving = true
