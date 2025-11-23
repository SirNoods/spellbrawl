extends Node

class_name NetworkManager

@export var player_scene: PackedScene = preload("res://scenes/player.tscn")
@export var default_spawn_position: Vector2 = Vector2(160, 160)

var peer: ENetMultiplayerPeer

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func host(port := 9000):
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(port, 8)
	if err != OK:
		push_error("Failed to host server: %s" % err)
		return
	multiplayer.multiplayer_peer = peer
	print("Hosting on port ", port)

	# Host needs a local player
	_spawn_player(multiplayer.get_unique_id(), default_spawn_position)

func join(address: String, port := 9000):
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(address, port)
	if err != OK:
		push_error("Failed to join server: %s" % err)
		return
	multiplayer.multiplayer_peer = peer
	print("Joining %s:%d" % [address, port])

func _on_peer_connected(id: int):
	print("Peer connected: ", id)
	if multiplayer.is_server():
		var spawn_pos := default_spawn_position + Vector2(randi_range(-32, 32), randi_range(-32, 32))
		rpc("spawn_player", id, spawn_pos)

func _on_peer_disconnected(id: int):
	print("Peer disconnected: ", id)
	var node_name = "Player_%d" % id
	var node = get_tree().current_scene.get_node_or_null(node_name)
	if node:
		node.queue_free()

func _on_connected_to_server():
	print("Connected to server.")

func _on_connection_failed():
	push_error("Connection to server failed.")
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	push_error("Disconnected from server.")
	multiplayer.multiplayer_peer = null

@rpc("any_peer", "call_local")
func spawn_player(id: int, position: Vector2):
	_spawn_player(id, position)

func _spawn_player(id: int, position: Vector2):
	if player_scene == null:
		push_error("NetworkManager: player_scene is not set!")
		return

	var player = player_scene.instantiate()
	player.name = "Player_%d" % id
	player.global_position = position

	if player.has_variable("is_local"):
		player.is_local = (id == multiplayer.get_unique_id())

	get_tree().current_scene.add_child(player)
