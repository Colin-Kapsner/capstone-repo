extends "state.gd"

var wall_jump_lock = false
var manipulated_jump = false
var last_wall_on = Vector2.ZERO

func update(delta):
	Player.gravity(delta)
	if !manipulated_jump:
		player_movement()
	jump_movement()
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.velocity == Vector2.ZERO:
		return STATES.IDLE
	if Player.dash_input and Player.has_dash:
		return STATES.DASH
	return null

func jump_movement():
	if wall_jump_lock:
		Player.velocity.x = -last_wall_on.x * Player.SPEED
	if Player.jump_input == false:
		if Player.velocity.y < Player.min_jump_velocity:
			Player.velocity.y /= 2
func enter_state():
	if Player.prev_state == STATES.WALLSLIDE:
		if Player.last_wall_on == Vector2.RIGHT:
			last_wall_on == Vector2.RIGHT
			Player.velocity.x = -Player.JUMP_VELOCITY / 2
		else:
			last_wall_on = Vector2.LEFT
			Player.velocity.x = Player.JUMP_VELOCITY / 2
		wall_jump_lock = true
	if !manipulated_jump:
		Player.velocity.y += Player.max_jump_velocity
func exit_state():
	wall_jump_lock = false
	manipulated_jump = false
	last_wall_on = Vector2.ZERO

