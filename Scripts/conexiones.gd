extends Node

@onready var ip = $GridContainer/IP
@onready var chat_ui = $ChatUI
@onready var grid_container = $GridContainer
@onready var name_input = $GridContainer/NameInput

const DEFAULT_IP = "192.168.100.100"
const PORT = 4200

var peer: ENetMultiplayerPeer
var user_names = {} # Diccionario para guardar los nombres de cada peer
var player_has_connected = false # Variable para rastrear el estado de conexión

# Señales para comunicación entre nodos
signal server_started
signal client_connected
signal player_connected(id, name)

func _ready():
	peer = ENetMultiplayerPeer.new()
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _input(event):
	if event.is_action_pressed("my_ui_accept"):
		prueba()
# Crear el servidor
func create_server(port):
	var result = peer.create_server(port)
	if result == OK:
		print("Servidor iniciado en el puerto: ", port)
		multiplayer.multiplayer_peer = peer
		emit_signal("server_started")
	else:
		print("Error al iniciar el servidor: ", result)

# Conectar a un servidor
func connect_to_server(server_ip: String, port: int):
	var result = peer.create_client(server_ip, port)
	if result != OK:
		print("Error al conectarse al servidor:", result)
		return
		
	multiplayer.multiplayer_peer = peer
	emit_signal("client_connected")
	print("Conectado al servidor: ", server_ip, ". en el puerto: ", port)

# Desconectar servidor/cliente
func server_disconnect():
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close_connection()
		multiplayer.multiplayer_peer = null
		print("Desconectado correctamente.")
		toggle_ui_on_connection(false)

# Manejar conexiones
func _on_peer_connected(id: int):
	var player_name = name_input.text.strip_edges()
	if player_name == "":
		player_name = "Jugador_{id}".format({"id":id})
		
	user_names[id] = player_name
	
	emit_signal("player_connected", id, user_names[id])
	print("Se conectó el jugador {name} ({id})".format({"name":user_names[id], "id":id}))
	
	rpc("broadcast_player_name", id, user_names[id])
	
	if multiplayer.is_server():
		rpc_id(id, "sync_player_list", user_names)

func _on_peer_disconnected(id: int):
	user_names.erase(id)
	print("El jugador {id} se desconectó.".format({"id":id}))
	
	if multiplayer.is_server():
		for peer_id in multiplayer.get_peers():
			rpc_id(peer_id, "sync_player_list", user_names)

# Validar dirección IP
func is_valid_ip(server_ip: String) -> bool:
	return server_ip.is_valid_ip_address()

@rpc("any_peer")
func broadcast_player_name(id: int, player_name: String):
	if multiplayer.is_server():
		user_names[id] = player_name
		
		for peer_id in multiplayer.get_peers():
			if peer_id != id:
				rpc_id(peer_id, "update_player_name", id, player_name)
				
		for peer_id in multiplayer.get_peers():
			rpc_id(peer_id, "sync_player_list", user_names)
	else:
		print("El jugador con id {id} se llama {player_name}".format({"id":id, "player_name":player_name}))

@rpc("any_peer")
func update_player_name(id: int, player_name: String):
	print("El jugador con ID ", id, " se llama ", player_name)

@rpc("any_peer")
func sync_player_list(player_list: Dictionary):
	user_names = player_list  # Sincronizar la lista completa de jugadores
	print("Lista de jugadores sincronizada: ", user_names)

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

func prueba():
	print(user_names)

# Alternar la visibilidad (TEMPORAL)
func toggle_ui_on_connection(state: bool):
	player_has_connected = state
	chat_ui.visible = state
	grid_container.visible = not state
