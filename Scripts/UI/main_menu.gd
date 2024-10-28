extends Control

var local_scene = ("res://Scenes/UI/localMenu.tscn")

func _on_local_pressed():
	get_tree().change_scene_to_file(local_scene)
