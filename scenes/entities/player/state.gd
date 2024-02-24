extends Node


var STATES = null
var Player = null

func enter_state():
	pass

func exit_state():
	pass

func update(delta):
	return null

func player_movement():
	if Player.movement_input.x != 0:
		Player.last_direction.x = Player.movement_input.x
	if Player.movement_input.x > 0:
		Player.velocity.x = move_toward(Player.velocity.x, Player.SPEED, Player.acceleration)
	elif Player.movement_input.x < 0:
		Player.velocity.x = move_toward(Player.velocity.x, -Player.SPEED, Player.acceleration)
	elif Player.movement_input.x == 0 and Player.velocity.x != 0:
			Player.velocity.x -= Player.friction
		
