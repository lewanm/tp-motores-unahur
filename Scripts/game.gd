extends Node2D # Or Node2D.



func _ready():
	# Preconfigure game.
	#Lobby.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.
	pass

# Called only on the server.
func start_game():
	# All peers are ready to receive RPCs in this scene.
	print("it workz")
