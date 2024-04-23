extends Node2D

var myPrefs = UserPreferences.load_or_create()


func _ready():
	get_window().mode = Window.MODE_FULLSCREEN
	# The below line will DELETE ALL USER PREFERENCES, DO NOT UNCOMMENT!!!
	#DirAccess.remove_absolute("user://user_prefs.tres")
	#print(get_tree().root.content_scale_size.x)

func _on_play_pressed():
	if myPrefs.user_token == "":
		get_tree().change_scene_to_file("res://signup.tscn")
	else:
		get_tree().change_scene_to_file("res://world.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_leaderboard_pressed():
	if myPrefs.user_token == "":
		get_tree().change_scene_to_file("res://scenes/signup.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")
