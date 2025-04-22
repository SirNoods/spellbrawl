extends Area2D

@export var bullet_speed = 100

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * bullet_speed * delta


func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
