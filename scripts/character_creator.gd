extends Node2D

var player_title = ""


func _on_confirm_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
