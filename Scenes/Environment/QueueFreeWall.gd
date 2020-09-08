extends Area2D

func _on_QueueFreeWall_body_entered(body):
	print(" body Deleteing")
	body.queue_free()


func _on_QueueFreeWall_area_entered(area):
	print(" area Deleteing")
	area.queue_free()
