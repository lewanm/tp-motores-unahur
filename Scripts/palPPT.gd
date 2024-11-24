extends Node

var peer: ENetMultiplayerPeer

func _ready():
	peer = ENetMultiplayerPeer.new()
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected():
	pass

func _on_peer_disconnected():
	pass

func create_server(PORT):
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

func create_client(IP_ADDRESS, PORT):
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
