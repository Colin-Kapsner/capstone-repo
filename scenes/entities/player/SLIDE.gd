extends "state.gd"



var slide_boost = 100
var sliding = false

func update(delta):
	if !sliding:
		return STATES.FALL
	return null
func enter_state():
	var initial_speed = Player.velocity.x
	sliding = true
	Player.has_dash = false
	Player.velocity = Player.initial_speed.normalized() * slide_boost
func exit_state():
	sliding = false
