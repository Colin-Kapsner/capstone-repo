extends "state.gd"

var manipulated_jump = false

# locking player movement after wall jump
var wall_jump_lock = false


func enter_state():
	Player.last_wall_on = Player.get_next_to_wall()
	# If on wall and in air
	if Player.get_next_to_wall() != null and !Player.is_on_floor():
		if Player.last_wall_on == Vector2.RIGHT:
			Player.velocity.x = -Player.JUMP_VELOCITY
		else:
			Player.velocity.x = Player.JUMP_VELOCITY
		wall_jump_lock = true
	if Player.is_on_floor():
		Player.has_dash = true
	# Jump
	Player.velocity.y = Player.max_jump_velocity


# TODO need fixed jump distance when walljumping
func update(delta):
	Player.gravity(delta)
	if Player.jump_input_actuation and !Player.has_double_jumped:
		Player.has_double_jumped = true
		return STATES.JUMP
	if !wall_jump_lock and Player.prev_state != $"../SLIDE":
		player_movement()
	jump_movement()
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.dash_input and Player.has_dash:
		return STATES.DASH
	
	if Player.is_on_floor():
		return STATES.MOVE
	return null

func jump_movement():
	if wall_jump_lock:
		Player.velocity.x = -Player.last_wall_on.x * (Player.SPEED - 50)
	if Player.jump_input == false:
		if Player.velocity.y < Player.min_jump_velocity:
			Player.velocity.y /= 2


func exit_state():
	wall_jump_lock = false
	manipulated_jump = false
