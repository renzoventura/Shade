extends KinematicBody2D
var levels = [1,2,3,4]
var list_of_speed = [20, 10, 5, 5]
var list_of_max_speed = [850, 300, 200, 150]
var list_of_scales = [0.75, 1.0, 1.5, 5]
var number_of_lives = [1, 2, 3, 5]
var motion = Vector2(0,0)
var motion_up = Vector2(0,-1)
var SPEED = 5;
var MAX_SPEED = 600
var current_speed = 10;
var JUMP_SPEED = 1800;
var GRAVITY = 700;
var MAX_FALL_SPEED = 3000
var life
var ACCELERATION = 5
var HURT_JUMP_SPEED = -3000
var HURT_SPEED = 600
var is_moving = true
var rng = RandomNumberGenerator.new()

var player
onready var timer = $Timer

func _ready():
	set_physics_process(true)
	rng.randomize()
	var random = rng.randi_range(0, 3)
	scale = Vector2(list_of_scales[random], list_of_scales[random])
	life = number_of_lives[random]
	SPEED = list_of_speed[random]
	MAX_SPEED = list_of_max_speed[random]

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
	timer.start()
	is_moving = false
	life -= 1
	var direction = 1
	if(!is_facing_right):
		direction = -1
	motion.x = HURT_SPEED * direction
	motion.y = HURT_JUMP_SPEED
	die()

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
	if(life <= 0):
		queue_free()

func _on_Timer_timeout():
	is_moving = true
