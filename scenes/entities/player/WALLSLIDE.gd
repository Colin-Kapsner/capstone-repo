extends "state.gd"


@export var climb_speed = 50
@export var wallslide_friction = .7


func enter_state():
	Player.has_dash = true
	Player.last_wall_on = Player.get_next_to_wall()

func update(delta):
	Player.has_dash = true
	player_movement()
	Player.gravity(delta)
	Player.velocity.y *= wallslide_friction
	if Player.get_next_to_wall() == null:
		return STATES.FALL
	if Input.is_action_just_pressed("Jump"):
		return STATES.JUMP
	if Player.is_on_floor():
			return STATES.IDLE
	return null                                                                                        

