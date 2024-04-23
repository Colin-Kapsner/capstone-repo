extends Node2D

# http_request.request(url)
var entered_username
var entered_password

# request variables
@onready var signup_request = $"Signup Request"
@onready var bearer_token_request = $"Bearer token request"
var data_to_send

# urls to give requests
var signup_url = "http://leaderboard-api.csci.fun/api/signup"
var bearer_token_url = "http://leaderboard-api.csci.fun/api/v1/login/token"

func _ready():
	get_window().mode = Window.MODE_FULLSCREEN

func _on_submit_pressed():
	if $Username.text != "" and $Password.text != "":
		entered_username = $Username.text
		entered_password = $Password.text
		data_to_send = {"data":{"type": "users","attributes": {"username": entered_username,"password": entered_password,"device_name": "Placeholder"}}}
		# getting request ready
		var query = JSON.stringify(data_to_send)
		var headers = ["Content-Type: application/json"]
		signup_request.request(signup_url, headers, HTTPClient.METHOD_POST, query)
		



func _on_signup_request_request_completed(result, response_code, headers, body):
	var myPrefs = UserPreferences.load_or_create()
	myPrefs.user_token = JSON.parse_string(body.get_string_from_utf8()).token
	myPrefs.save()
	get_tree().change_scene_to_file("res://menu.tscn")
