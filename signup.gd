extends Node2D

# http_request.request(url)


# request variables
var signup_request = "Signup Request"
var bearer_token_request = "Bearer token request"

# urls to give requests
var signup_url = "http://leaderboard-api.csci.fun/api/signup"
var bearer_token = "http://leaderboard-api.csci.fun/api/signup"


func _on_submit_pressed():
	signup_request.request(signup_url)
	bearer_token_request



func _on_bearer_token_request_request_completed(result, response_code, headers, body):
	# Store data in user prefs
	pass


#{data:{type:"",attributes:{"username":"password","":""}}}
