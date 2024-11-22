extends Control

@onready var chat_display = $VBoxContainer/PanelContainer/ChatDisplay
@onready var input_field = $VBoxContainer/HBoxContainer/InputField
@onready var conexiones = get_node("/root/Conexiones") #cambiar esto despues por señales

func _ready():
	input_field.connect("text_submitted", Callable(self,"_on_text_submitted"))
	self.hide()

@rpc("any_peer")
func send_chat_message(player_name: String, message: String):
	if chat_display:
		chat_display.add_text(player_name + ": " + message + "\n")

func _on_text_submitted(text: String):
	if text.strip_edges(true,true) == "": #Para envitar que se envien mensajes vacios
		return
	
	var player_name = conexiones.user_names.get(multiplayer.get_unique_id(), "Jugador Desconocido")
	
	#Enviar el mensaje localmente y sincronizarlo.
	self.send_chat_message(player_name,text)
	rpc("send_chat_message",player_name, text)
	input_field.text = ""

func _on_button_pressed():
	self._on_text_submitted(input_field.text)
