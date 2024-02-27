extends "state.gd"

var manipulated_jump = false
var has_jump = true
# locking player movement after wall jump
var wall_jump_lock = false


func update(delta):
	Player.gravity(delta)
	if !wall_jump_lock:
		player_movement()
	jump_movement()
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.dash_input and Player.has_dash:
		return STATES.DASH
	return null

func jump_movement():
	if wall_jump_lock:
		Player.velocity.x = -Player.last_wall_on.x * Player.SPEED
	if Player.jump_input == false:
		if Player.velocity.y < Player.min_jump_velocity:
			Player.velocity.y /= 2
func enter_state():
	Player.last_wall_on = Player.get_next_to_wall()
	if has_jump:
		# Wall Jump
		if Player.get_next_to_wall() != null and !Player.is_on_floor():
			if Player.last_wall_on == Vector2.RIGHT:
				Player.velocity.x = -Player.JUMP_VELOCITY / 2
			else:
				Player.velocity.x = Player.JUMP_VELOCITY / 2
			wall_jump_lock = true
			
			# TODO OR PASSES THROUGH RESET
		#elif Player.is_on_floor() or Player.get_next_to_wall() != null:
		#	has_jump = true
		#else:
		#has_jump = false
		Player.velocity.y += Player.max_jump_velocity
func exit_state():
	wall_jump_lock = false
	manipulated_jump = false
	Player.last_wall_on = Vector2.ZERO

