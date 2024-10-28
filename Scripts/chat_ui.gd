extends Control

@onready var chat_display = $VBoxContainer/PanelContainer/ChatDisplay
@onready var input_field = $VBoxContainer/HBoxContainer/InputField

func _ready():
	input_field.connect("text_submitted", Callable(self,"_on_text_submitted"))
	self.hide()

@rpc("any_peer")
func send_chat_message(message: String):
	if chat_display:
		chat_display.add_text(message + "\n")

func _on_text_submitted(text: String):
	if text.strip_edges(true,true) == "": #Para envitar que se envien mensajes vacios
		return
	
	self.send_chat_message(text)
	
	rpc("send_chat_message", text)
	
	input_field.text = ""

func _on_button_pressed():
	self._on_text_submitted(input_field.text)
