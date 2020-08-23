extends AnimatedSprite

func _on_Player_animate(motion, GRAVITY, is_facing_right):
	if is_facing_right:
		flip_h = false
	else:
		flip_h = true
	if motion.y < 0: 
		play("jump")
	elif motion.y > GRAVITY: 
		play("fall")
	elif motion.x != 0:
		play("move")
	else: 
		play("idle")

func _on_Player_attackAnimate():
	play("attack")
