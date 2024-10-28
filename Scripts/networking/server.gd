extends Node

signal player_has_connected(data)

const PORT = 4200
const MIIP = "localhost"

var peer: ENetMultiplayerPeer

var player_data = {}

func create_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

func connect_to_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(MIIP,PORT)
	multiplayer.multiplayer_peer = peer

#señal que recibe el servidor cuando alguien se conecta (esto incluye al mismo que hostea el sv)
func _on_peer_connected(id:int = 1):
	#var player_scene = load("res://Scripts/character_body_2d.tscn")
	#var player_instance = player_scene.instantiate()
	#player_instance.name = str(id)
	#add_child(player_instance,true)
	#self.anounce_player_connection_in_chat(id)
	print("se conecto el player {id}".format({"id":id}))
	
	
func anounce_player_connection_in_chat(player):
	emit_signal("player_has_connected", player)
	
#Cambiar estas 2 funciones de Global a recibir una señal despues.
func _on_host_pressed():
	self.create_server()
	#multiplayer.peer_connected.connect(_on_peer_connected)
	#self._on_peer_connected()

func _on_join_pressed():
	self.connect_to_server()
