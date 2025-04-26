extends Node2D

@onready var hat_sprite = $Sprite2D4

# keys
var hat_keys = []
var colour_keys = []
var current_hat_index = 0
var current_colour_index = 0

func _ready() -> void:
	set_sprite_keys()
	update_sprite()

# set keys
func set_sprite_keys():
	hat_keys = Global.hats_collection.keys()

#update texture and modulate
func update_sprite():
	var current_sprite = hat_keys[current_hat_index]
	if current_sprite == "none":
		hat_sprite.texture = null
	else:
		hat_sprite.texture = Global.hats_collection[current_sprite]
		hat_sprite.modulate = Global.hat_colour_options[current_colour_index]
	Global.selected_hat = current_sprite
	Global.selected_hat_colour = Global.hat_colour_options[current_colour_index]


func _on_collection_button_pressed() -> void:
	current_hat_index = (current_hat_index + 1) % Global.hats_collection.size()
	update_sprite()


func _on_colour_button_pressed() -> void:
	current_colour_index = (current_colour_index + 1) % Global.hat_colour_options.size()
	update_sprite()
