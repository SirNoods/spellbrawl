extends CanvasLayer

@export var player_path : NodePath
@onready var player : Node = get_node_or_null(player_path)
@onready var fps_label : Label = $MarginContainer/VBoxContainer/FpsLabel
@onready var state_label : Label = $MarginContainer/VBoxContainer/PlayerStateLabel
@onready var aim_label : Label = $MarginContainer/VBoxContainer/AimInfoLabel
@onready var title_label : Label = $MarginContainer/VBoxContainer/DebugTitleLabel
@onready var scene_label: Label = $MarginContainer/VBoxContainer/SceneLabel
@onready var pos_label: Label = $MarginContainer/VBoxContainer/PosLabel

var visible_overlay := false
var version_text := "Version: unknown"

func _ready():
	set_process(true)
	visible = visible_overlay
	version_text = _load_version_text()
	title_label.text = "Spellbrawl " + version_text

func _process(_delta):
	if Input.is_action_just_pressed("toggle_debug"):
		visible_overlay = !visible_overlay
		visible = visible_overlay
	
	scene_label.text = "Scene: %s" % get_tree().current_scene.name
	if player:
		pos_label.text = "Pos: (%.1f, %.1f)" % [player.global_position.x, player.global_position.y]
	
	if not visible_overlay:
		return
	
	# FPS
	fps_label.text = "FPS: %d" % Engine.get_frames_per_second()

	# Player info
	if player:
		state_label.text = "Player State: %s" % str(player.current_state)
		aim_label.text = "Velocity: %s" % str(player.velocity)

func _load_version_text() -> String:
	var f := FileAccess.open("res://VERSION.txt", FileAccess.READ)
	if f:
		var ver := f.get_as_text().strip_edges()
		f.close()
		return ver
	return "unknown"


func _on_toggle_slowmo_pressed() -> void:
	Engine.time_scale = 0.2 if Engine.time_scale == 1.0 else 1.0
