extends Node

@onready var ip = $GridContainer/IP
@onready var chat_ui = $ChatUI
@onready var grid_container = $GridContainer
@onready var name_input = $GridContainer/NameInput

const DEFAULT_IP = "192.168.100.100"
const PORT = 4200

var player_has_connected = false # Variable para rastrear el estado de conexión

func _ready():
	NETWORK.server_started.connect(_on_server_started)
	NETWORK.client_connected.connect(_on_client_connected)
	NETWORK.user_names_updated.connect(_on_user_names_updated)

func _on_host_pressed():
	NETWORK.create_server(PORT)
	#toggle_ui_on_connection(true)

func _on_join_pressed():
	var valid_ip = ip.text.strip_edges() if ip.text != "" else DEFAULT_IP
	if !is_valid_ip(valid_ip):
		print("Dirección IP inválida:", valid_ip)
		return
	NETWORK.connect_to_server(valid_ip, PORT)
	#_toggle_ui_on_connection(true)

func _on_server_started():
	print("Servidor iniciado.")
	_toggle_ui_on_connection(true)

func _on_client_connected():
	print("Conectado al servidor")
	_toggle_ui_on_connection(true)

func _on_user_names_updated(user_names: Dictionary):
	print("usuarios actualizados: ", user_names)

func is_valid_ip(server_ip: String) -> bool:
	return server_ip.is_valid_ip_address()

# Alternar la visibilidad (TEMPORAL)
func _toggle_ui_on_connection(state: bool):
	chat_ui.visible = state
	$GridContainer.visible = not state
