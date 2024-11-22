extends Node

@onready var ip = $GridContainer/IP
@onready var chat_ui = $ChatUI
@onready var grid_container = $GridContainer
@onready var name_input = $GridContainer/NameInput

const DEFAULT_IP = "192.168.100.100"
const PORT = 4200

var peer: ENetMultiplayerPeer
var user_names = {} # Diccionario para guardar los nombres de cada peer

signal server_started
signal client_connected
signal player_connected(id, name)

func _ready():
	peer = ENetMultiplayerPeer.new()
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _input(event):
	if event.is_action_pressed("my_ui_accept"):
		print(user_names)
		print(multiplayer.get_peers())

func create_server(port):
	var result = peer.create_server(port)
	if result == OK:
		multiplayer.multiplayer_peer = peer
		emit_signal("server_started")
		print("Servidor iniciado en el puerto:", port)
		
		#agregar al host como usuario
		var host_id = multiplayer.get_unique_id()
		var host_name = name_input.text.strip_edges() if name_input.text.strip_edges() != "" else "Host"
		user_names[host_id] = host_name
	else:
		print("Error al iniciar el servidor. Código de error:", result)

func connect_to_server(server_ip: String, port: int):
	var result = peer.create_client(server_ip, port)
	if result == OK:
		multiplayer.multiplayer_peer = peer
		emit_signal("client_connected")
		print("Conectado al servidor en IP:", server_ip, " y puerto:", port)
	else:
		print("Error al conectarse al servidor. Código de error:", result)

func _on_peer_connected(id: int):
	if multiplayer.is_server():
		var player_name = "Jugador_{id}".format({"id": id})
		user_names[id] = player_name
		emit_signal("player_connected", id, player_name)
		print("Se conectó el jugador {name} ({id})".format({"name": player_name, "id": id}))
		rpc("sync_player_list", user_names)
	else:
		print("Cliente: Peer conectado con ID: ", id)

func _on_peer_disconnected(id: int):
	print("Se desconecto ({id})".format({"id":id}))

@rpc("any_peer")
func sync_player_list(updated_user_names: Dictionary):
	user_names = updated_user_names  # Sincronizar la lista completa de jugadores
	print("Se sincroniza correctamente la lista: ", updated_user_names)
	

func is_valid_ip(server_ip: String) -> bool:
	return server_ip.is_valid_ip_address()

# Botones
func _on_host_pressed():
	create_server(PORT)
	toggle_ui_on_connection(true)

func _on_join_pressed():
	var _ip = ip.text.strip_edges() if ip.text != "" else DEFAULT_IP
	if !is_valid_ip(_ip):
		print("Dirección IP inválida:", _ip)
		return
		
	connect_to_server(_ip, PORT)
	toggle_ui_on_connection(true)

# Alternar la visibilidad (TEMPORAL)
func toggle_ui_on_connection(state: bool):
	chat_ui.visible = state
	grid_container.visible = not state
