extends CharacterBody2D

@export var movement_speed : float = 100

@export var dash_speed : float = 600
var dashing = false
var can_dash = true

var character_direction : Vector2
var last_direction = "down"

var dying = false

func _ready():
	$AnimatedSprite2D.material.set_shader_parameter("dissolveValue", 1)

func _physics_process(delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	
	# running	
	if character_direction and not dying:
		
		if dashing:
			velocity = character_direction * dash_speed
		else:
			velocity = character_direction * movement_speed
		
		if character_direction.x > 0:
			if dashing:
				$AnimatedSprite2D.animation = "dash_right"
			else:
				$AnimatedSprite2D.animation = "run_right"
			last_direction = "right"
		if character_direction.x < 0:
			if dashing:
				$AnimatedSprite2D.animation = "dash_left"
			else:
				$AnimatedSprite2D.animation = "run_left"
			last_direction = "left"
		if character_direction.y > 0:
			if dashing:
				$AnimatedSprite2D.animation = "dash_down"
			else:
				$AnimatedSprite2D.animation = "run_down"
			last_direction = "down"
		if character_direction.y < 0:
			if dashing:
				$AnimatedSprite2D.animation = "dash_up"
			else:
				$AnimatedSprite2D.animation = "run_up"
			last_direction = "up"
	
	# idling
	elif not character_direction and not dying:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		match last_direction:
			"up":
				$AnimatedSprite2D.animation = "idle_up"
			"left":
				$AnimatedSprite2D.animation = "idle_left"
			"right":
				$AnimatedSprite2D.animation = "idle_right"
			"down":
				$AnimatedSprite2D.animation = "idle_down"
		
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$DashTimer.start()
		$DashCooldown.start()
	move_and_slide()
	
	if Input.is_action_just_pressed("die"):
		dying = true
		player_death()
	
	# debugHUD
	if can_dash:
		$DebugHud/DashCooldownLabel.text = "dashcooldown: 0"
		
	else:
		$DebugHud/DashCooldownLabel.text = "dashcooldown: " + str(int(round($DashCooldown.time_left)))

func player_death():
	$AnimatedSprite2D.animation = "death_"+last_direction
	$AnimatedSprite2D/AnimationPlayer.play("dissolve")
	$DeathTimer.start()
# timers

func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_cooldown_timeout() -> void:
	can_dash = true


func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
