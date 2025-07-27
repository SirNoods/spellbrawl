extends Control

const PORT: int = 3000

var main_scene: PackedScene = preload("uid://cb3u7k67b2t3f")

@onready var host_button: Button = $HBoxContainer/HostButton
@onready var join_button: Button = $HBoxContainer/JoinButton

func _ready() -> void:
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_play_pressed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	
func _on_host_pressed() -> void:
	var server_peer := ENetMultiplayerPeer.new()
	server_peer.create_server(PORT)
	multiplayer.multiplayer_peer = server_peer
	get_tree().change_scene_to_packed(main_scene)
	
	
func _on_play_pressed() -> void:
	var client_peer := ENetMultiplayerPeer.new()
	client_peer.create_client("127.0.0.1", PORT)
	multiplayer.multiplayer_peer = client_peer
	get_tree().change_scene_to_packed(main_scene)
	
func _on_peer_connected(id: int):
	print("my peer id: %s" % multiplayer.get_unique_id())
	print("peer connected %s" % id)
