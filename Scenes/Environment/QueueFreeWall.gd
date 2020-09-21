extends Area2D

func _on_QueueFreeWall_body_entered(body):
	body.queue_free()

func _on_QueueFreeWall_area_entered(area):
	area.queue_free()
