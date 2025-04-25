extends Node2D

@onready var hair_sprite = $Sprite2D2

# keys
var hair_keys = []
var colour_keys = []
var current_hair_index = 0
var current_colour_index = 0

func _ready() -> void:
	set_sprite_keys()
	update_sprite()

# set keys
func set_sprite_keys():
	hair_keys = Global.hair_collection.keys()

#update texture and modulate
func update_sprite():
	var current_sprite = hair_keys[current_hair_index]
	if current_sprite == "none":
		hair_sprite.texture = null
	else:
		hair_sprite.texture = Global.hair_collection[current_sprite]
		hair_sprite.modulate = Global.hair_colour_options[current_colour_index]
	Global.selected_hair = current_sprite
	Global.selected_hair_colour = Global.hair_colour_options[current_colour_index]
