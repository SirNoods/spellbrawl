extends CharacterBody2D


# --- Exports ---
@export var movement_speed : float = 100
@export var dash_speed : float = 600
@export var dash_duration : float = 0.2
@export var dash_cooldown : float = 1.0
@export var aim_range : float = 40.0

# --- States ---
enum State {IDLE, RUNNING, DASHING, DYING}
var current_state : State = State.IDLE
var last_direction = "down" # Stores facing direction for animations

# --- Timers ---
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldown

func _ready():
	# setting timers
	dash_timer.wait_time = dash_duration
	dash_cooldown_timer.wait_time = dash_cooldown
	# resetting dissolve effect
	$AnimatedSprite2D.material.set_shader_parameter("dissolveValue", 1)
	current_state = State.IDLE
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# State Logic
	match current_state:
		State.IDLE:
			handle_idle(input_dir)
		State.RUNNING:
			handle_running(input_dir)
		State.DASHING:
			handle_dashing(input_dir)
		State.DYING:
			handle_dying()

	move_and_slide()
	
	# Handle Aiming (skip during Dying)
	if current_state != State.DYING:
		update_aiming(delta)

# --- State Handlers ---
func handle_idle(input_dir: Vector2):
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
	if input_dir.length() > 0:
		current_state = State.RUNNING
	elif Input.is_action_just_pressed("die"):
		die()
		current_state = State.DYING
	

func handle_running(input_dir: Vector2):
	velocity = input_dir * movement_speed
	update_last_direction(input_dir)
	$AnimatedSprite2D.animation = "run_"+last_direction
	if input_dir.length() == 0:
		current_state = State.IDLE
	elif Input.is_action_just_pressed("dash") and dash_cooldown_timer.is_stopped():
		start_dash(input_dir)
	elif Input.is_action_just_pressed("die"):
		current_state = State.DYING
		die()
	
func handle_dashing(input_dir: Vector2):
	$AnimatedSprite2D.animation = "dash_"+last_direction
	
func handle_dying():
	velocity = Vector2.ZERO

func update_aiming(delta: float):
	var mouse_pos := get_global_mouse_position()
	var camera := get_viewport()
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
	
# --- Helper Functions ---
func die():
	$AnimatedSprite2D.animation = "death_"+last_direction
	$AnimatedSprite2D/AnimationPlayer.play("dissolve")
	$DeathTimer.start()
	

func start_dash(input_dir: Vector2):
	if input_dir.length() == 0:
		input_dir = Vector2.DOWN.rotated(rotation) # dash in facing direction if no input
	velocity = input_dir.normalized() * dash_speed
	current_state = State.DASHING
	dash_timer.start()
	dash_cooldown_timer.start()


func update_last_direction(input_dir: Vector2):
	if input_dir.x > 0:
		last_direction = "right"
	elif input_dir.x < 0:
		last_direction = "left"
	elif input_dir.y > 0:
		last_direction = "down"
	elif input_dir.y < 0:
		last_direction = "up"

# --- Timer Callbacks ---
func _on_dash_timer_timeout():
	current_state = State.RUNNING if Input.get_vector("move_left", "move_right", "move_up", "move_down").length() > 0 else State.IDLE

func _on_death_timer_timeout():
	get_tree().reload_current_scene()
