extends "state.gd"


func enter_state():
	Player.has_dash = true
	Player.has_double_jumped = false



func update(delta):
	Player.gravity(delta)
	player_movement()
	if Player.velocity.x == 0:
		return STATES.IDLE
	if Player.velocity.y > 0:
		Player.has_dash = true
		return STATES.FALL
	if Player.is_on_floor() and Input.is_action_pressed("Jump"):
		return STATES.JUMP
	if Player.dash_input and Player.has_dash:
		return STATES.DASH
	if Input.is_action_pressed("Slide"):
		return $"../SLIDE"
	return null
