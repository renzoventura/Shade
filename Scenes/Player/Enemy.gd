extends KinematicBody2D


var motion = Vector2(0,0)
var motion_up = Vector2(0,-1)

var SPEED = 20;
var JUMP_SPEED = 1800;
var GRAVITY = 2000;
var MAX_FALL_SPEED = 3000

export(int) var ACCELERATION = 10

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	apply_gravity()
	var player = get_tree().get_root().find_node("Player", true, false)
	if player != null:
		chase_player(player, delta)

func chase_player(player, delta):
	var direction = (player.global_position - global_position).normalized()
#	motion += direction * ACCELERATION * delta
#	motion = motion.clamped(SPEED)
	motion += direction * ACCELERATION
	$AnimatedSprite.flip_h = global_position > player.global_position
	motion = move_and_slide(motion)

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

func hurt():
	print("OUCH!")
	motion.y -= 500
	motion.x = 300

	
func apply_gravity():
	if is_on_floor() and motion.y > 0: 
		motion.y = 0
	elif is_on_ceiling():
		motion.y = 1
	else:
		if(motion.y < MAX_FALL_SPEED):
			motion.y += GRAVITY
