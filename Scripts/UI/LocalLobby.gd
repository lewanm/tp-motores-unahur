extends Control

@onready var chat_display = $ChatContainer/PanelContainer/ChatDisplay
@onready var input_field = $ChatContainer/HBoxContainer/InputField
@onready var conexiones = get_node("/root/Conexiones") #cambiar esto despues por señales
@onready var player_info_label = $PlayerInfo

var player_name = ""
var user_names = {}

func _ready():
	conexiones.connect("player_list_updated", Callable(self, "_on_player_name_assigned"))
	input_field.connect("text_submitted", Callable(self,"_on_text_submitted"))
	self.hide()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print(user_names)

func _on_player_name_assigned(updated_user_names: Dictionary):
	self.player_name = updated_user_names.get(multiplayer.get_unique_id(), "Jugador Desconocido")
	self.user_names = updated_user_names
	#player_info_label.text = self.player_name
	self.update_player_labels()
	#print("Nombre del jugador actualizado en el chat: ", player_name)

func update_player_labels():
	#print("update_player_labels llamado. Usuarios:", user_names)
	var players_container = $PlayersContainer/GridContainer
	var children = players_container.get_children()
	
	var index = 0
	for id in user_names.keys():
		if index >= children.size():
			break
		
		if children[index] is Label:
			children[index].text = user_names[id]
			print("Etiqueta actualizada en índice", index, ":", user_names[id])
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

func _on_button_pressed():
	self._on_text_submitted(input_field.text)


func _on_back_button_pressed():
	
	conexiones.toggle_ui_on_connection(false)
