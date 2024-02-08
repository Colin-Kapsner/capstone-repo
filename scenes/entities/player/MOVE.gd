extends "state.gd"


func update(delta):
	Player.gravity(delta)
	player_movement()
	if Player.velocity != 0 and !Player.player_input():
		Player.velocity.x = move_toward(Player.velocity.x, 0, Player.acceleration)
	if Player.velocity.x == 0:
		return STATES.IDLE
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.jump_input_actuation:
		return STATES.JUMP
	if Player.dash_input and Player.has_dash:
		return STATES.DASH
	return null
func enter_state():
	Player.has_dash = true
