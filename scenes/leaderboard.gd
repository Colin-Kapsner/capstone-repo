extends Node

@onready var global_times_request = $"CanvasLayer/Refresh/Global Leaderboard Request"
@onready var personal_times_request = $"CanvasLayer/Refresh/Personal Times Request"
var myPrefs = UserPreferences.load_or_create()
var headers = ["Content-Type: application/json", "Authorization: Bearer " + myPrefs.user_token]

var global_times_url = "http://leaderboard-api.csci.fun/api/alltoptimes"
var personal_times_url = "http://leaderboard-api.test/api/v1/toptimes"


func _ready():
	get_window().mode = Window.MODE_FULLSCREEN
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	update_leaderboard()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
func _on_refresh_pressed():
	update_leaderboard()
func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

func update_leaderboard():
	global_times_request.request(global_times_url, headers)
	personal_times_request.request(personal_times_url, headers)


func _on_global_leaderboard_request_request_completed(result, response_code, headers, body):
	var global_leaderboard_data = JSON.parse_string(body.get_string_from_utf8())
	
	var current_place = 1
	for time in global_leaderboard_data.data:
		$CanvasLayer/Leaderboard.text += (str(current_place) + "." + "     " + str(time.attributes.time) + "     " + time.attributes.user + "\n")
		current_place += 1


func _on_personal_times_request_request_completed(result, response_code, headers, body):
	#var personal_times_data = JSON.parse_string(body.get_string_from_utf8())
	#$"CanvasLayer/Personal Best".text = personal_times_data
	pass


