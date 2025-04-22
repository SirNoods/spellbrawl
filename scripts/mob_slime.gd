extends CharacterBody2D

@onready var player = get_node("/root/game/Player/")

@export var movement_speed = 1

func _physics_process(delta: float) -> void:
	var direction  = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	move_and_slide()

func take_damage():
	queue_free()
