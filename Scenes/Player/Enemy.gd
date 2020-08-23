extends KinematicBody2D


var motion = Vector2(0,0)
var motion_up = Vector2(0,-1)

var SPEED = 20;
var JUMP_SPEED = 1800;
var GRAVITY = 2000;
var MAX_FALL_SPEED = 3000

var life = 3

export(int) var ACCELERATION = 10

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	apply_gravity()
	var player = get_tree().get_root().find_node("Player", true, false)
	if player != null:
		chase_player(player, delta)
	animate()
	die()

func chase_player(player, delta):
	var direction = (player.global_position - global_position).normalized()
	motion += direction * ACCELERATION
	$Sprite.flip_h = global_position > player.global_position
	motion = move_and_slide(motion)

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

func hurt(var is_facing_right):
	print("OUCH!")
	life -= 1
	var direction = 1
	if(!is_facing_right):
		direction = -1
	motion.y -= 700
	motion.x = 500 * direction

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

func die():
	if(life < 0):
		queue_free()
