extends "state.gd"


@export var climb_speed = 50
@export var wallslide_friction = .7

func update(delta):
	wallslide_movement(delta)
	friction()
	if Player.get_next_to_wall() == null:
		return STATES.FALL
	if Player.jump_input_actuation:
		return STATES.JUMP
	if Player.is_on_floor():
			return STATES.IDLE
	return null
func enter_state():
	Player.last_wall_on = Player.get_next_to_wall()
func wallslide_movement(delta):
	pass
	if Player.climb_input:
		if Player.movement_input.y < 0:
			Player.velocity.y = -climb_speed
		elif Player.movement_input.y > 0:
			Player.velocity.y = -climb_speed
		else:
			Player.velocity.y = 0
	else:
		player_movement()
		Player.gravity(delta)
		Player.velocity.y *= wallslide_friction
func friction():
	Player.velocity.y *= wallslide_friction
