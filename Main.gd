extends Node2D

var player_name = "John Doe"
var time = randi() % 101
@onready var leaderboard_scene = preload("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func _ready():
	get_window().mode = Window.MODE_FULLSCREEN

func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")

func _on_quit_pressed():
	get_tree().quit()


func _on_submit_pressed():
	
	var inputtext = $LineEdit.text
	player_name = inputtext
	SilentWolf.Scores.save_score(player_name, time)
	get_tree().change_scene_to_packed(leaderboard_scene)
	
