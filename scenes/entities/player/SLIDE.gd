extends "state.gd"

var slide_direction = Vector2.ZERO
var slide_friction = 5
var slide_boost = 150
var slide_jump_boost = 100
var sliding = false


func enter_state():
	Player.has_double_jumped = false
	sliding = true
	if Player.movement_input != Vector2.ZERO:
		slide_direction = Player.movement_input
	else:
		slide_direction = Player.last_direction
	Player.velocity.x += slide_direction.x * slide_boost



func update(delta):
	Player.gravity(delta)
	slide_movement()
	if Input.is_action_pressed("Jump"):
		Player.velocity.x += slide_jump_boost * slide_direction.x
		return STATES.JUMP
	if Input.is_action_just_released("Slide") and Player.velocity.x <= Player.SPEED:
		return STATES.MOVE
	if Input.is_action_just_released("Slide") and Player.velocity.x >= Player.SPEED:
		return STATES.MOVE
	if Player.velocity.x == 0:
		return STATES.IDLE
	if !sliding:
		return STATES.FALL
	return null


func exit_state():
	sliding = false
func slide_movement():
	if Player.velocity.x > Player.SPEED/2:
		Player.velocity.x = move_toward(Player.velocity.x, Player.SPEED/2, slide_friction)
	if Player.velocity.x < -Player.SPEED/2:
		Player.velocity.x = move_toward(Player.velocity.x, -Player.SPEED/2, slide_friction)
