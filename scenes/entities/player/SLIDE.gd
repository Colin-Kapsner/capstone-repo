extends "state.gd"

var slide_direction = Vector2.ZERO
var slide_friction = 5
var slide_boost = 600
var slide_jump_boost = 200
var sliding = false

func update(delta):
	Player.gravity(delta)
	slide_movement()
	if Input.is_action_pressed("Jump"):
		Player.velocity += slide_jump_boost * slide_direction.normalized()
		return STATES.JUMP
	if !Input.is_action_pressed("Slide") and Player.velocity.x <= Player.SPEED:
		return STATES.MOVE
	if Player.velocity.x == 0:
		return STATES.IDLE
	if !sliding:
		return STATES.FALL
	return null
func slide_movement():
	if Player.velocity.x > Player.SPEED/2:
		Player.velocity.x = move_toward(Player.velocity.x, Player.SPEED/2, slide_friction)
	if Player.velocity.x < Player.SPEED/2:
		Player.velocity.x = move_toward(Player.velocity.x, -Player.SPEED/2, slide_friction)
func enter_state():
	sliding = true
	Player.has_dash = false
	if Player.movement_input != Vector2.ZERO:
		slide_direction = Player.movement_input
	else:
		slide_direction = Player.last_direction
	Player.velocity = slide_direction.normalized() * slide_boost
func exit_state():
	sliding = false
