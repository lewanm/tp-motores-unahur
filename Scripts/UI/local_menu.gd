extends Control

var prev_scene = ("res://Scenes/UI/mainMenu.tscn")
var local_lobby_menu = ("res://Scenes/UI/localLobbymenu.tscn") 

func _on_back_btn_pressed():
	get_tree().change_scene_to_file(prev_scene)


func _on_button_pressed():
	get_tree().change_scene_to_file(local_lobby_menu)
