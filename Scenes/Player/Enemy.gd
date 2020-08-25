extends KinematicBody2D

var motion = Vector2(0,0)
var motion_up = Vector2(0,-1)
var SPEED = 10;
var MAX_SPEED = 600
var current_speed = 10;
var JUMP_SPEED = 1800;
var GRAVITY = 2000;
var MAX_FALL_SPEED = 3000
var life = 3
export(int) var ACCELERATION = 5
var player

func _ready():
	set_physics_process(true)
	
var is_animating = false;

func _physics_process(delta):
	apply_gravity()
	player = get_tree().get_root().find_node("Player", true, false)
	
	if(not is_animating):
		if player != null:
			chase_player(delta)
		animate()
	die()
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
	is_animating = true
	life -= 1
	var direction = 1
	if(global_position > player.global_position):
		direction = -1
	motion.y -= 700
	motion.x = 5000 * direction
	is_animating = false

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
