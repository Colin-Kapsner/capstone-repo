extends "state.gd"


func enter_state():
	Player.velocity.x = 0
	Player.has_dash = true
	Player.has_jump = true
	


func update(delta):
	
	Player.gravity(delta)
	if Player.movement_input.x != 0:
		return STATES.MOVE
	if Player.jump_input_actuation and Player.has_jump:
		return STATES.JUMP
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.dash_input and Player.has_dash:
		return STATES.DASH
	return null
