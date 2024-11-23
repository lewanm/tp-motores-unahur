extends Node

signal server_started
signal client_connected
signal player_connected(id, name)
signal user_names_updated(user_names)

var peer: ENetMultiplayerPeer
var user_names = {} # Diccionario para guardar los nombres de cada peer

func create_server(port: int) -> void:
	peer = ENetMultiplayerPeer.new()
	var result = peer.create_server(port)
	if result == OK:
		print("Servidor iniciado en el puerto: ", port)
		multiplayer.multiplayer_peer = peer
		emit_signal("server_started")
	else:
		print("Error al iniciar el servidor: ", result)

func connect_to_server(server_ip: String, port: int) -> void:
	peer = ENetMultiplayerPeer.new()
	var result = peer.create_client(server_ip, port)
	if result == OK:
		multiplayer.multiplayer_peer = peer
		emit_signal("client_connected")
		print("Conectado al servidor: ", server_ip, ". en el puerto: ", port)
	else:
		print("Error al conectarse al servidor:", result)

@rpc("any_peer")
func broadcast_player_name(id: int, player_name: String):
	user_names[id] = player_name
	emit_signal("user_names_updated", user_names)
	print("El jugador con ID", id, "se llama", player_name)
	#if multiplayer.is_server():
		#user_names[id] = player_name
		#
		#for peer_id in multiplayer.get_peers():
			#if peer_id != id:
				#rpc_id(peer_id, "update_player_name", id, player_name)
				#
		#for peer_id in multiplayer.get_peers():
			#rpc_id(peer_id, "sync_player_list", user_names)
	#else:
		#print("El jugador con id {id} se llama {player_name}".format({"id":id, "player_name":player_name}))


#func _on_peer_connected(id: int):
	#var player_name = name_input.text.strip_edges()
	#if player_name == "":
		#player_name = "Jugador_{id}".format({"id":id})
		#
	#user_names[id] = player_name
	#
	#emit_signal("player_connected", id, user_names[id])
	#print("Se conectó el jugador {name} ({id})".format({"name":user_names[id], "id":id}))
	#
	#rpc("broadcast_player_name", id, user_names[id])
	#
	#if multiplayer.is_server():
		#rpc_id(id, "sync_player_list", user_names)

#func _on_peer_disconnected(id: int):
	#user_names.erase(id)
	#print("El jugador {id} se desconectó.".format({"id":id}))
	#
	#if multiplayer.is_server():
		#for peer_id in multiplayer.get_peers():
			#rpc_id(peer_id, "sync_player_list", user_names)
#
#
#
#
##Esto es solo de prueba
#@rpc("any_peer")
#func update_player_name(id: int, player_name: String):
	#print("El jugador con ID ", id, " se llama ", player_name)
#
#@rpc("any_peer")
#func sync_player_list(player_list: Dictionary):
	#user_names = player_list  # Sincronizar la lista completa de jugadores
	#print("Lista de jugadores sincronizada: ", user_names)
