extends Node




func _ready():
	
  SilentWolf.configure({
	"api_key": "gQtwlLUAJ36ZSoEKr4Gc820Vq6ds0Pmd6igerDf9",
	"game_id": "test22",
	"log_level": 1
  })

  SilentWolf.configure_scores({
	"open_scene_on_close": "res://main.tscn"
  })
