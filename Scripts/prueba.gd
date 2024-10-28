extends Node

@onready var ip = $GridContainer/IP
@onready var chat_ui = $ChatUI
@onready var grid_container = $GridContainer


const DEFAULT_IP = "192.168.100.100"
const PORT = 4200

var peer: ENetMultiplayerPeer

func _ready():
	peer = ENetMultiplayerPeer.new()

func create_server(port):
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	self._on_peer_connected()

func connect_to_server(ip: String, port: int):
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer


func _on_peer_connected(id: int = 1):
	print("se conecto el player {id}".format({"id":id}))


func _on_host_pressed():
	self.create_server(PORT)
	self.prueba()


func _on_join_pressed():
	var _ip
	if ip.text == "":
		_ip = DEFAULT_IP
	else:
		_ip = ip.text
		
	self.connect_to_server(_ip, PORT)
	self.prueba()

func prueba():
	chat_ui.visible = true
	grid_container.visible = false
	
