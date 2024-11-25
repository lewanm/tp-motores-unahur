extends Node2D

@export var player_scene: PackedScene

#No se si lo voy a usar pero lño agrego por si las dudas
var user_names = {}

func _ready():
	if multiplayer.is_server():
		for id in multiplayer.get_peers():
			_create_player_for_peer(id)
		_create_player_for_peer(multiplayer.get_unique_id())

@rpc("any_peer")
func _create_player_for_peer(peer_id):
	
		
	var player = player_scene.instantiate()
	player.name = "Player_{id}".format({"id": peer_id})
	
	player.position = Vector2(100  , 100)
	add_child(player, true)
	
	if peer_id == multiplayer.get_unique_id():
		player.set_physics_process(true)
	else:
		player.set_physics_process(false)
		

func update_user_names(new_user_names):
	self.user_names = new_user_names

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print(user_names)
		print(multiplayer.get_peers())


#func _ready():

#
