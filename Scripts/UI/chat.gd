extends Node

@onready var chat_box = $ChatContainer/ChatBox
@onready var text_box = $ChatContainer/MessageContainer/TextBox
@onready var send_button = $ChatContainer/MessageContainer/SendButton

var text_box_is_focused = false

func _ready():
	NETWORK.connect("player_has_connected", Callable(self, "_on_player_connected"))

func _input(event):
	if event.is_action_pressed("my_ui_accept") && text_box_is_focused:
		self.send_message()

func _on_button_pressed():
	self.send_message()

func _on_player_connected(data):
	print(data)
	var new_connection_message = "Se conecto player {playerId} a la sala".format({"playerId" : data })
	add_new_message(new_connection_message, "SERVER" )

func send_message():
	if text_box.text != "":
		self.add_new_message(text_box.text) ##ver como carajos le mando el player que lo esta usando
		text_box.text = ""
	

func add_new_message(_message,_player = "uknown"):
	var data = {
		"player": _player,
		"message": _message
	}
	var message = "[{player}]: {message}".format(data)
	var history = self.chat_box.text
	
	chat_box.text = history + message + "\n" ##Ver si lo dejo asi, o si guardo el historial de verdad
	#Cambiar esto por un scrollbox y cada mensaje nuevo un lineedit nuevo.


func _on_text_box_focus_entered():
	text_box_is_focused = true


func _on_text_box_focus_exited():
	text_box_is_focused = false

func _on_host_pressed():
	NETWORK._on_host_pressed()


func _on_join_pressed():
	NETWORK._on_join_pressed()
