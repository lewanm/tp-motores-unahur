extends Node

@onready var ip = $GridContainer/IP
@onready var chat_ui = $ChatUI
@onready var grid_container = $GridContainer

const DEFAULT_IP = "192.168.100.100"
const PORT = 4200

var peer: ENetMultiplayerPeer
var user_names = {} #diccionario para guardar los nombres de cada peer

# Señales para comunicacion entre nodos
signal server_started
signal client_connected
signal peer_connected(id, name)

func _ready():
	peer = ENetMultiplayerPeer.new()
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

# Crear el servidor
func create_server(port):
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	emit_signal("server_started") #para notificar que el sv esta listo
	#multiplayer.peer_connected.connect(_on_peer_connected)
	#self._on_peer_connected()

# Conectar a un servidor
func connect_to_server(ip: String, port: int):
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	emit_signal("client_connected") #Para notificar cuando se conectaron como cliuente


#Manejando las conexiones
func _on_peer_connected(id: int = 1):
	print("se conecto el player {id}".format({"id":id}))
	emit_signal("peer_connected", id)
	

func _on_peer_disconnected(id: int = 1):
	print("se conecto el player {id}".format({"id":id}))


#Botones

func _on_host_pressed():
	create_server(PORT)
	toggle_ui_on_connection()


func _on_join_pressed():
	var _ip = ip.text.strip_edges() if ip.text != "" else DEFAULT_IP
	connect_to_server(_ip, PORT)
	toggle_ui_on_connection()


#alternar la visibilidad ESTO ES TEMPORAL
func toggle_ui_on_connection():
	chat_ui.visible = true
	grid_container.visible = false
	
