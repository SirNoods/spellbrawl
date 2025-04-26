extends Node2D

@onready var body_sprite = $Sprite2D

# keys
var body_keys = []
var colour_keys = []
var current_body_index = 0
var current_colour_index = 0

func _ready() -> void:
	set_sprite_keys()
	update_sprite()

# set keys
func set_sprite_keys():
	body_keys = Global.bodies_collection.keys()

#update texture and modulate
func update_sprite():
	var current_sprite = body_keys[current_body_index]
	body_sprite.texture = Global.bodies_collection[current_sprite]
	body_sprite.modulate = Global.body_colour_options[current_colour_index]
	Global.selected_body = current_sprite
	Global.selected_skin_colour = Global.body_colour_options[current_colour_index]


func _on_colour_button_pressed() -> void:
	current_colour_index = (current_colour_index + 1) % Global.body_colour_options.size()
	update_sprite()
