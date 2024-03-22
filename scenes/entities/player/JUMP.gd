extends "state.gd"


# locking player movement after wall jump
var wall_jump_lock = false


func enter_state():
	# Setting last wall
	Player.last_wall_on = Player.get_next_to_wall()
	# If on wall and in air
	if Player.get_next_to_wall() != null and !Player.is_on_floor():
		if Player.last_wall_on == Vector2.RIGHT:
			Player.velocity.x = -Player.JUMP_VELOCITY
		else:
			Player.velocity.x = Player.JUMP_VELOCITY
		wall_jump_lock = true
	if Player.is_on_floor() or !Player.coyote_timer.is_stopped():
		Player.has_dash = true
		Player.has_jump = true
	# Jump
	Player.velocity.y = Player.max_jump_velocity
	


func update(delta):
	Player.gravity(delta)
	if Player.get_next_to_wall() != null:
		Player.has_jump = true
	if Player.jump_input_actuation and Player.has_jump:
		Player.has_jump = false
		return STATES.JUMP
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.dash_input and Player.has_dash:
		return STATES.DASH
	if Player.is_on_floor():
		return STATES.MOVE
	# if not walljumping or slide jumping
	if !wall_jump_lock and Player.prev_state != $"../SLIDE":
		player_movement()
	jump_movement()
	return null

func jump_movement():
	if wall_jump_lock:
		Player.velocity.x = -Player.last_wall_on.x * (Player.SPEED + 50)
	if Player.jump_input == false:
		if Player.velocity.y < Player.min_jump_velocity:
			Player.velocity.y /= 2


func exit_state():
	wall_jump_lock = false
