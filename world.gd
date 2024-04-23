extends Node2D

var myPrefs = UserPreferences.load_or_create()

func _ready():
	if myPrefs.user_token == "" or myPrefs.user_token == null:
		get_tree().change_scene_to_file("res://signup.tscn")
