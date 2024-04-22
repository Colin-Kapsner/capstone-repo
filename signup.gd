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
		data_to_send = [entered_username, entered_password]
	# Convert data to json string:
	var query = JSON.stringify(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	signup_request.request(signup_url, headers, HTTPClient.METHOD_POST, query)
	bearer_token_request.request(bearer_token_url, headers, HTTPClient.METHOD_POST, query)




func _on_bearer_token_request_request_completed(result, response_code, headers, body):
	# Store data in user prefs
	var token = JSON.parse_string(body.get_string_from_utf8())
	print(token)
	#$"res://resources/user_preferences.gd".user_token = token


#{data:{type:"",attributes:{"username":"password","":""}}}


func _on_signup_request_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
