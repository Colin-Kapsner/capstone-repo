extends "state.gd"


@export var wallslide_friction = .7


func enter_state():
	Player.has_jump = true
	Player.last_wall_on = Player.get_next_to_wall()

func update(delta):
	player_movement()
	Player.gravity(delta)
	Player.velocity.y *= wallslide_friction
	if Player.get_next_to_wall() == null:
		return STATES.FALL
	if Player.jump_input_actuation and Player.has_jump:
		return STATES.JUMP
	if Player.is_on_floor():
		return STATES.IDLE
	return null                                                                                        

