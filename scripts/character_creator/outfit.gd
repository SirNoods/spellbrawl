extends Node2D

@onready var outfit_sprite = $Sprite2D3

# keys
var outfit_keys = []
var colour_keys = []
var current_outfit_index = 0
var current_colour_index = 0

func _ready() -> void:
	set_sprite_keys()
	update_sprite()

# set keys
func set_sprite_keys():
	outfit_keys = Global.outfits_collection.keys()

#update texture and modulate
func update_sprite():
	var current_sprite = outfit_keys[current_outfit_index]
	outfit_sprite.texture = Global.outfits_collection[current_sprite]
	outfit_sprite.modulate = Global.outfit_colour_options[current_colour_index]
	Global.selected_outfit = current_sprite
	Global.selected_outfit_colour = Global.outfit_colour_options[current_colour_index]


func _on_collection_button_pressed() -> void:
	current_outfit_index = (current_outfit_index + 1) % Global.outfits_collection.size()
	update_sprite()


func _on_colour_button_pressed() -> void:
	current_colour_index = (current_colour_index + 1) % Global.outfit_colour_options.size()
	update_sprite()
