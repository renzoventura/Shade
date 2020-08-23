extends KinematicBody2D

var is_attacking

var motion = Vector2(0,0)
var motion_up = Vector2(0,-1)
var SPEED = 800;
var JUMP_SPEED = 1800;
var GRAVITY = 200;
var MAX_FALL_SPEED = 300

onready var playerAnimation = $PlayerAnimation
onready var attackArea = $AttackArea
onready var attackAreaCollision = $AttackArea/AttackCollision

signal animate
signal attackAnimate

var is_facing_right;

func ready():
	is_facing_right = true;
	attackArea.set_collision_mask_bit(2, false)
	is_attacking = false
	
func _process(delta):
	apply_gravity()
	if not is_attacking:
		walk()
		jump()
		animate()
		attack()
		update_attack_collision()
	move_and_slide(motion, motion_up)

func walk():
	if Input.is_action_pressed("left") and not Input.is_action_just_pressed("right"):
		motion.x = -SPEED
		is_facing_right = false
	elif Input.is_action_pressed("right") and not Input.is_action_just_pressed("left"):
		motion.x = SPEED
		is_facing_right = true
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
		
func attack():
	if Input.is_action_just_pressed("attack"):
		attackAnimate()


func animate():
	if not is_attacking:
		emit_signal("animate", motion, GRAVITY, is_facing_right)
	
func attackAnimate():
	is_attacking = true
	attackAreaCollision.disabled = false
	emit_signal("attackAnimate")
	yield(get_node("PlayerAnimation"), "animation_finished")
	is_attacking = false
	attackAreaCollision.disabled = true

func _on_AttackArea_body_entered(body):
	body.hurt()

func update_attack_collision():
	pass
