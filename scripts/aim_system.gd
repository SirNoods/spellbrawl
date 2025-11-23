extends Node2D

class_name AimSystem

@export var aim_range := 40.0
@export var projectile_scene : PackedScene = preload("res://scenes/weaponry/basic_projectile.tscn")
@export var attack_cooldown := 0.3
@onready var attack_cooldown_timer: Timer = $AttackCooldown  # Explicit timer reference


var can_attack := true
var player : Node2D

func _ready():
	player = get_parent()
	if player == null:
		push_error("AimSystem must be a child of Player")

func _physics_process(_delta):
	if !player: return
	
	# Mouse aiming
	var mouse_pos := get_global_mouse_position()
	var to_mouse := mouse_pos - global_position
	var distance := to_mouse.length()
	# Determine final position
	var aim_pos: Vector2
	if distance <= aim_range:
		aim_pos = mouse_pos  # Use exact mouse position when within range
	else:
		aim_pos = global_position + (to_mouse.normalized() * aim_range)  # Clamp to max range
	
	# Update aiming
	$AimController.look_at(aim_pos)
	$AimOffset.position = (aim_pos - global_position)  # Will be exact mouse pos or clamped
	
	
	# Shooting
	if Input.is_action_just_pressed("shoot") and can_attack:
		shoot()

func shoot():
	if projectile_scene == null:
		push_error("AimSystem: projectile_scene is not set!")
		return
	can_attack = false
	$AttackCooldown.start(attack_cooldown)
	var new_projectile = projectile_scene.instantiate()
	new_projectile.global_position = $AimController/SpellSpawnpoint.global_position
	new_projectile.global_rotation = $AimController/SpellSpawnpoint.global_rotation
	get_tree().current_scene.add_child(new_projectile)
	

func _on_attack_cooldown_timeout():
	can_attack = true
