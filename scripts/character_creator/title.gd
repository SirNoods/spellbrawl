extends Node2D

var current_title_index = 0

func _ready() -> void:
	$Title.text = Global.selected_title

func update_title():
	var current_title = Global.title_options[current_title_index]
	Global.selected_title = current_title
	$Title.text = Global.selected_title


func _on_collection_button_pressed() -> void:
	current_title_index = (current_title_index + 1) % Global.title_options.size()
	update_title()
