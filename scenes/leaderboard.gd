extends Node

@onready var global_times_request = $"CanvasLayer/Refresh/Global Leaderboard Request"
@onready var personal_times_request = $"CanvasLayer/Refresh/Personal Times Request"


var global_times_url = "http://leaderboard-api.csci.fun/api/alltoptimes"
var personal_times_url = "http://leaderboard-api.test/api/v1/toptimes"


func _ready():
	get_window().mode = Window.MODE_FULLSCREEN
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	# http_request.request(url)
	global_times_request.request(global_times_url)
	personal_times_request.request(personal_times_url)



func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://world.tscn")

func _on_refresh_pressed():
	global_times_request.request(global_times_url)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_personal_times_request_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	print(data["data"][1]["attributes"]["time"])


func _on_global_leaderboard_request_request_completed(result, response_code, headers, body):
	var global_leaderboard_data = JSON.parse_string(body.get_string_from_utf8())
	print(global_leaderboard_data)
