extends Control

@onready var chat_display = $ChatContainer/PanelContainer/ChatDisplay
@onready var input_field = $ChatContainer/HBoxContainer/InputField
@onready var conexiones = get_tree().get_nodes_in_group("conexiones")[0]
@onready var start_game = $StartGame

var player_scene = load("res://Scenes/Player.tscn")

var player_name = ""
var user_names = {}

func _ready():
	conexiones.connect("player_list_updated", Callable(self, "_on_player_name_assigned"))
	input_field.connect("text_submitted", Callable(self,"_on_text_submitted"))
	self.hide()



func _on_player_name_assigned(updated_user_names: Dictionary):
	if multiplayer.is_server():
		print("Soy el server")
	else:
		print("Soy el cliente")
	print("Updated user names: ", updated_user_names)
	self.player_name = updated_user_names.get(multiplayer.get_unique_id(), "Desconocido")
	self.user_names = updated_user_names
	self.update_player_labels()

func update_player_labels():
	print("update_player_labels llamado. Usuarios:", user_names)
	var players_container = $PlayersContainer/GridContainer
	var children = players_container.get_children()
	print("Nodos en players_container: ", children.size())
	
	var index = 0
	for id in user_names.keys():
		if index >= children.size():
			break
		
		if children[index] is Label:
			children[index].text = user_names[id]
			print("Etiqueta actualizada en índice ", index, ":", user_names[id])
		index += 1
	
	while index < children.size():
		if children[index] is Label:
			children[index].text = ""
		index += 1
	
@rpc("any_peer")
func send_chat_message(_player_name: String, message: String):
	chat_display.add_text(_player_name + ": " + message + "\n")

func _on_text_submitted(text: String):
	if text.strip_edges(true,true) == "": #Para envitar que se envien mensajes vacios
		return
	
	#Enviar el mensaje localmente y sincronizarlo.
	self.send_chat_message(player_name,text)
	rpc("send_chat_message",player_name, text)
	input_field.text = ""


func _on_back_button_pressed():
	
	conexiones.toggle_ui_on_connection(false)


func _on_button_button_up():
	self._on_text_submitted(input_field.text)

@rpc("any_peer")
func load_game_scene():
	get_tree().change_scene_to_file("res://Scenes/Game/game_scene.tscn")

func _on_start_game_pressed():
	if not multiplayer.is_server():
		self.send_chat_message("Juego","Solo el host puede iniciar.")
		return
	
	rpc("load_game_scene")

	await get_tree().create_timer(0.1).timeout
	
	get_tree().change_scene_to_file("res://Scenes/Game/game_scene.tscn")
