extends Node2D


func _ready():
	get_window().mode = Window.MODE_FULLSCREEN
	
	pass

func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_leaderboard_pressed():
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")
