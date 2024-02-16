extends "state.gd"



var slide_boost
var sliding = false

func update(delta):
	if !sliding:
		return STATES.FALL
	if Player.get_next_to_wall() != null:
		return STATES.WALLSLIDE
	return null
func enter_state():
	var initial_speed = Player.velocity.x
	Player.has_dash = false
	sliding = true
	Player.velocity = Player.initial_speed.normalized() * slide_boost
func exit_state():
	sliding = false
