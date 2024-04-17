extends Node

@onready var http_request = $CanvasLayer/Refresh/HTTPRequest
@onready var rich_text_label = $CanvasLayer/RichTextLabel


var url = "https://Leaderboard-API.test/api/alltoptimes"


func _ready():
	get_window().mode = Window.MODE_FULLSCREEN
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	
	

func _on_button_pressed():
	http_request.request(url)


func _on_http_request_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	print(data)


func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://world.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_refresh_pressed():
	http_request.request(url)
