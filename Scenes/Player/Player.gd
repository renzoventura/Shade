extends KinematicBody2D

enum States {IDLE, HURT, SHIELD, DASH}
enum SoundEffects {ATTACK, HURT, SHIELD, DEATH, BLOCKED}
var currentState = States.IDLE
var is_attacking
var is_facing_right
var motion = Vector2(0,0)
var motion_up = Vector2(0,-1)
var SPEED = 800;
var JUMP_SPEED = 2500;
var GRAVITY = 200;
var MAX_FALL_SPEED = 1200
var lives = 5
var KNOCK_BACK_SPEED = 500

onready var leftAttackArea = $AttackArea
onready var leftAttackAreaCollision = $AttackArea/AttackCollision
onready var rightAttackArea = $AttackArea2
onready var rightAttackAreaCollision = $AttackArea2/AttackCollision
onready var animationPlayer = $Sprite/AnimationPlayer
onready var player_sfx = $PlayerSFX
onready var dash_timer = $DashTimer

var attack_sfx = load("res://Assets/sfx/player_attack.wav")
var hurt_sfx = load("res://Assets/sfx/player_hurt.wav")
var shield_sfx = load("res://Assets/sfx/shield.wav")
var blocked_sfx = load("res://Assets/sfx/blocked.wav")
#var death_sfx = load()

signal animate
signal attackAnimate
signal hurtAnimate
signal shieldAnimate
signal dashAnimate

func _ready():
	lives = 5
	is_facing_right = true;
	is_attacking = false;
	currentState = States.IDLE
	update_gui()
	
func _process(delta):
	apply_gravity()
	if currentState == States.IDLE:
		if not is_attacking:
			walk()
			animate()
			jump()
			attack()
			dash()
			shield()
	elif currentState == States.HURT:
		damaged()
	elif currentState == States.SHIELD:
		use_shield()
	elif currentState == States.DASH:
		dashing()
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
	if Input.is_action_just_pressed("attack") and not Input.is_action_just_pressed("shield"):
		is_attacking = true
		if(is_facing_right):
			leftAttackAreaCollision.disabled = false
		else:
			rightAttackAreaCollision.disabled = false
		motion.x = 0
		play_sound(SoundEffects.ATTACK)
		animateAttack()
		yield(get_node("Sprite/AnimationPlayer"), "animation_finished")
		is_attacking = false
		leftAttackAreaCollision.disabled = true
		rightAttackAreaCollision.disabled = true

func _on_AttackArea_body_entered(body):
	body.hurt(is_facing_right)

func _on_AttackArea2_body_entered(body):
	body.hurt(is_facing_right)

func dash():
	if Input.is_action_just_pressed("dash"):
		change_state(States.DASH)
		dash_timer.start()

func animate():
	emit_signal("animate", motion, is_facing_right)

func animateAttack():
	emit_signal("attackAnimate")

func animateHurt():
	emit_signal("hurtAnimate")

func hurt(isLeft):
	if(currentState != States.SHIELD):
		play_sound(SoundEffects.HURT)
		lives = lives - 1
		update_gui()
		if(isLeft):
			motion.x = -KNOCK_BACK_SPEED
		else:
			motion.x = KNOCK_BACK_SPEED
		change_state(States.HURT)
	else: 
		play_sound(SoundEffects.BLOCKED)

func checkIfDead():
	if(lives <= 0):
		get_tree().call_group("GameState", "playerDied")

func damaged():
	animateHurt()
	checkIfDead()

func animationFinished():
	change_state(States.IDLE)

func knockBack():
	motion.x = 200
	
func change_state(new_state):
	if new_state == currentState:
		return
	if new_state == States.HURT:
		pass
	if new_state == States.IDLE:
		pass
	if new_state == States.DASH:
		pass
	currentState = new_state

func update_gui():
	get_tree().call_group("GameState", "updateLives", lives)
	
func shield():
	if Input.is_action_just_pressed("shield") and not Input.is_action_just_pressed("attack"):
		motion.x = 0
		play_sound(SoundEffects.SHIELD)
		change_state(States.SHIELD)

func use_shield():
	emit_signal("shieldAnimate")

func play_sound(sfx):
	if (sfx == SoundEffects.ATTACK):
		player_sfx.stream = attack_sfx
	elif (sfx == SoundEffects.HURT):
		player_sfx.stream = hurt_sfx
	elif (sfx == SoundEffects.SHIELD):
		player_sfx.stream = shield_sfx
	elif (sfx == SoundEffects.DEATH):
		print("Play death music")
	elif(sfx == SoundEffects.BLOCKED):
		player_sfx.stream = blocked_sfx
	player_sfx.play()

func dashing():
	print("dashing")
	emit_signal("dashAnimate")
	if(is_facing_right):
		motion.x = 2000
	else: 
		motion.x = -2000
	pass

func _on_DashTimer_timeout():
	print("tim out!")
	change_state(States.IDLE)
