extends Node


var STATES = null
var Player = null

func enter_state():
	pass

func exit_state():
	pass

func update(delta):
	return null

# TODO MUST FIX - Whenever a state uses this, it clamps the players max speed to Player.SPEED
func player_movement():
	# Setting last_direction
	if Player.movement_input.x != 0:
		Player.last_direction.x = Player.movement_input.x
	# Speeding up
	if Player.movement_input.x > 0:
		Player.velocity.x = move_toward(Player.velocity.x, Player.SPEED, Player.acceleration)
	if Player.movement_input.x < 0:
		Player.velocity.x = move_toward(Player.velocity.x, -Player.SPEED, Player.acceleration)
	# Slowing down
	if Player.movement_input.x == 0 and Player.velocity.x != 0 and Player.is_on_floor():
			Player.velocity.x = move_toward(Player.velocity.x, 0, Player.friction)

# this is overkill
func player_air_movement():
	# Setting last_direction
	if Player.movement_input.x != 0:
		Player.last_direction.x = Player.movement_input.x

	# pressing right moving right
	if Player.movement_input.x > 0:
		Player.velocity.x += Player.acceleration/4
	# pressing right moving left
	if Player.movement_input.x < 0:
		Player.velocity.x -= Player.acceleration/4
