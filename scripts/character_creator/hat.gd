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
