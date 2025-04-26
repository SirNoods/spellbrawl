extends CharacterBody2D

# --- Exports ---
@export var movement_speed : float = 100
@export var dash_speed : float = 600
@export var dash_duration : float = 0.2
@export var dash_cooldown : float = 1.0

# --- States ---
enum State {IDLE, RUNNING, DASHING, DYING}
var current_state : State = State.IDLE
var last_direction = "down" # Stores facing direction for animations

# --- Timers ---
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldown
@onready var death_timer: Timer = $DeathTimer

# --- Character Sprites ---
@onready var body = $Skeleton/Body
@onready var hair = $Skeleton/Hair
@onready var outfit = $Skeleton/Outfit
@onready var hat = $Skeleton/Hat
@onready var staff = $Skeleton/Staff
@onready var name_label = $Skeleton/Name

func _ready():
	# setting timers
	dash_timer.wait_time = dash_duration
	dash_cooldown_timer.wait_time = dash_cooldown
	current_state = State.IDLE
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	initialize_player()


func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	print(current_state)
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

# --- State Handlers ---
func handle_idle(input_dir: Vector2):
	velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
	# TODO: Fill in Animation here
	match last_direction:
			"up":
				pass
			"left":
				pass
			"right":
				pass
			"down":
				pass
	if input_dir.length() > 0:
		current_state = State.RUNNING
	elif Input.is_action_just_pressed("die"):
		die()
		current_state = State.DYING
	

func handle_running(input_dir: Vector2):
	velocity = input_dir * movement_speed
	update_last_direction(input_dir)
	# TODO: Fill in animation here
	if input_dir.length() == 0:
		current_state = State.IDLE
	elif Input.is_action_just_pressed("dash") and dash_cooldown_timer.is_stopped():
		start_dash(input_dir)
	elif Input.is_action_just_pressed("die"):
		current_state = State.DYING
		die()
	
func handle_dashing(input_dir: Vector2):
	# TODO: Fill in animation here
	pass
func handle_dying():
	velocity = Vector2.ZERO

# --- Player initializing
func initialize_player():
	# skin tone
	body.modulate = Global.selected_skin_colour
	
	# hair and colour
	hair.texture = Global.hair_collection[Global.selected_hair]
	hair.modulate = Global.selected_hair_colour
	# hat and colour
	hat.texture = Global.hats_collection[Global.selected_hat]
	hat.modulate = Global.selected_hat_colour
	# outfit and colour
	outfit.texture = Global.outfits_collection[Global.selected_outfit]
	outfit.modulate = Global.selected_outfit_colour

# --- Helper Functions ---
func die():
	death_timer.start()
	

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
