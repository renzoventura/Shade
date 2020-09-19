extends Sprite


onready var animationPlayer = $AnimationPlayer

func _on_Player_animate(motion, is_facing_right):
	if is_facing_right:
		flip_h = false
	else:
		flip_h = true
	if motion.x != 0:
		animationPlayer.play("walk")
	else: 
		animationPlayer.play("idle")

func _on_Player_attackAnimate():
	animationPlayer.play("attack")

func _on_Player_hurtAnimate():
	animationPlayer.play("hurt")

func animationFinished():
	get_tree().call_group("Player", "animationFinished")

func _on_Player_shieldAnimate():
	animationPlayer.play("shield")

func _on_Player_dashAnimate():
	animationPlayer.play("dash")
