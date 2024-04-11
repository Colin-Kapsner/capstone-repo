extends Node

@onready var http_request = $CanvasLayer/Button/HTTPRequest
@onready var rich_text_label = $CanvasLayer/RichTextLabel


var url = "https://meowfacts.herokuapp.com/"


func _ready():
	get_window().mode = Window.MODE_FULLSCREEN
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

func _on_button_pressed():
	http_request.request(url)


func _on_http_request_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	$CanvasLayer/RichTextLabel.text = data.data[0]
