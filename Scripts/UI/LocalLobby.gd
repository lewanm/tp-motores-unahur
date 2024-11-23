extends Control

@onready var chat_display = $ChatContainer/PanelContainer/ChatDisplay
@onready var input_field = $ChatContainer/HBoxContainer/InputField
@onready var conexiones = get_node("/root/Conexiones") #cambiar esto despues por señales
@onready var player_info_label = $PlayerInfo

var player_name = ""

func _ready():
	conexiones.connect("player_name_assigned", Callable(self, "_on_player_name_assigned"))
	input_field.connect("text_submitted", Callable(self,"_on_text_submitted"))
	self.hide()

func _on_player_name_assigned(updated_user_names: Dictionary):
	print("Lista de usuarios asignada:", updated_user_names)
	self.player_name = updated_user_names.get(multiplayer.get_unique_id(), "Jugador Desconocido")
	player_info_label.text = self.player_name
	#print("Nombre del jugador actualizado en el chat: ", player_name)

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
