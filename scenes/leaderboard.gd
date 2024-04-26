extends Node

@onready var global_times_request = $"CanvasLayer/Refresh/Global Leaderboard Request"
@onready var personal_times_request = $"CanvasLayer/Refresh/Personal Times Request"
var myPrefs = UserPreferences.load_or_create()
var headers = ["Content-Type: application/json", "Authorization: Bearer " + myPrefs.user_token]

var global_times_url = "http://leaderboard-api.csci.fun/api/alltoptimes"
var personal_times_url = "http://leaderboard-api.csci.fun/api/v1/toptimes"


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
	$"CanvasLayer/Leaderboard Names".text = ""
	$"CanvasLayer/Leaderboard Times".text = ""
	$"CanvasLayer/Personal Leaderboard".text = ""
	global_times_request.request(global_times_url)
	personal_times_request.request(personal_times_url, headers, HTTPClient.METHOD_GET)


func _on_global_leaderboard_request_request_completed(result, response_code, headers, body):
	var global_leaderboard_data = JSON.parse_string(body.get_string_from_utf8())
	print(global_leaderboard_data)
	var leaderboard_place = 1
	for time in global_leaderboard_data.data:
		$"CanvasLayer/Leaderboard Names".text += (str(leaderboard_place) + "." + "    " + time.attributes.user + "\n")
		$"CanvasLayer/Leaderboard Times".text += (str(time.attributes.time) + "\n")
		leaderboard_place += 1
	
	


func _on_personal_times_request_request_completed(result, response_code, headers, body):
	var personal_times_data = JSON.parse_string(body.get_string_from_utf8())
	$"CanvasLayer/Personal Leaderboard".text += (str(personal_times_data.data[0].attributes.time) + "      \n")


