extends KinematicBody2D

enum States {CHASE, ATTACK, HURT, STOP}

const levels = [1,2,3]
const list_of_speed = [10, 5, 5]
const list_of_max_speed = [300, 200, 150]
const list_of_scales = [1.0, 1.5, 5]
const number_of_lives = [1, 3, 5]


const JUMP_SPEED = 1800;
const GRAVITY = 700;
const MAX_FALL_SPEED = 3000
const ACCELERATION = 5
const HURT_JUMP_SPEED = -30
const ATTACK_RANGE = 100
const HURT_SPEED = 1000

var SPEED = 5;
var MAX_SPEED = 600
var motion = Vector2(0,0)
var motion_up = Vector2(0,-1)
var current_speed = 10;
var life
var is_moving = true
var rng = RandomNumberGenerator.new()
var damage_direction = 1
var player
var state = null
var direction
onready var timer = $Timer

func _ready():
	set_physics_process(true)
	rng.randomize()
	var random = rng.randi_range(0, 2)
	scale = Vector2(list_of_scales[random], list_of_scales[random])
	life = number_of_lives[random]
	SPEED = list_of_speed[random]
	MAX_SPEED = list_of_max_speed[random]
	state = States.CHASE

func _physics_process(delta):
	apply_gravity()
	animate()
	get_direction()
	if state == States.STOP:
		stop()
	if state == States.CHASE:
		if player != null and is_moving:
			detect_if_within_attacking_range()
			chase_player(delta)
	if state == States.ATTACK:
		attack()
	if state == States.HURT:
		damaged()
	move_and_slide(motion)

func stop():
	while(not motion.y < 0 or not motion.x < 0):
		motion.x -= 100

func change_state(new_state):
	if new_state == state:
		return
	if new_state == States.ATTACK:
		pass
	if new_state == States.CHASE:
		pass
	if new_state == States.HURT:
		pass
	state = new_state

func get_direction():
	player = get_tree().get_root().find_node("Player", true, false)
	direction = (player.global_position - global_position)

func chase_player(delta):
	var enemyDirection = 1
	if(global_position > player.global_position):
		enemyDirection = -1
	if(current_speed <= MAX_SPEED):
		current_speed += SPEED
	motion.x = current_speed * enemyDirection
	$Sprite.flip_h = global_position > player.global_position

func detect_if_within_attacking_range():
	var distance_to_player = global_position.distance_to(player.global_position)
	if(distance_to_player < (ATTACK_RANGE * scale.x)):
		change_state(States.ATTACK)
	else: 
		change_state(States.CHASE)

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

func damaged():
	timer.start()
	$Sprite/AnimationPlayer.play("Hurt")
	yield(get_node("Sprite/AnimationPlayer"), "animation_finished")
	die()
	change_state(States.STOP)

func hurt(var is_facing_right):
	life -= 1
	if(is_facing_right):
		damage_direction = 1
	else: 
		damage_direction = -1
	motion.x = HURT_SPEED * damage_direction
	motion.y = HURT_JUMP_SPEED
	change_state(States.HURT)

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
	
func attack():
	clear_motion_x()
	$Sprite/AnimationPlayer.play("Attack")
	yield(get_node("Sprite/AnimationPlayer"), "animation_finished")
	change_state(States.STOP)
	
func clear_motion_x():
	motion.x = 0
