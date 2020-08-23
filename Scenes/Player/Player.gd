extends KinematicBody2D

var motion = Vector2(0,0)
var motion_up = Vector2(0,-1)
var SPEED = 1000;
var JUMP_SPEED = 3000;
var GRAVITY = 300;
var MAX_FALL_SPEED = 1500

func _process(delta):
	apply_gravity()
	walk()
	jump()
	move_and_slide(motion, motion_up)

func walk():
	if Input.is_action_pressed("left") and not Input.is_action_just_pressed("right"):
		motion.x = -SPEED
	elif Input.is_action_pressed("right") and not Input.is_action_just_pressed("left"):
		motion.x = SPEED
	else:
		motion.x = 0

func apply_gravity():
	if is_on_floor() and motion.y > 0: 
		motion.y = 0
	elif is_on_ceiling():
		motion.y = 1
	else:
		if(motion.y < MAX_FALL_SPEED):
			motion.y += GRAVITY

func jump():
	if Input.is_action_pressed("jump") and is_on_floor():
		motion.y -= JUMP_SPEED

