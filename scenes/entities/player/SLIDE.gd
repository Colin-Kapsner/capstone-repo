extends "state.gd"

var slide_direction = Vector2.ZERO
var slide_friction = 5
var slide_boost = 150
var slide_jump_boost = 100
var sliding = false


func enter_state():
	sliding = true
	Player.animations.play("slide_animation")
	Player.has_jump = true
	if Player.movement_input != Vector2.ZERO:
		slide_direction = Player.movement_input
	else:
		slide_direction = Player.last_direction
	Player.velocity.x += slide_direction.x * slide_boost



func update(delta):
	Player.gravity(delta)
	slide_movement()
	if Player.prev_state == STATES.DASH and abs(Player.velocity.x) > abs(Player.SPEED):
		Player.particles.emitting = true
	else:
		Player.particles.emitting = false
	if Player.jump_input_actuation and Player.has_jump:
		Player.velocity.x += slide_jump_boost * slide_direction.x
		return STATES.JUMP
	if Input.is_action_just_released("Slide") and Player.velocity.x <= Player.SPEED:
		return STATES.MOVE
	if Input.is_action_just_released("Slide") and Player.velocity.x >= Player.SPEED:
		return STATES.MOVE
	if Player.velocity.x == 0:
		return STATES.IDLE
	if !sliding:
		Player.has_dash = true
		return STATES.FALL
	return null

func slide_movement():
	if Player.velocity.x > Player.SPEED/2:
		Player.velocity.x = move_toward(Player.velocity.x, Player.SPEED/2, slide_friction)
	if Player.velocity.x < -Player.SPEED/2:
		Player.velocity.x = move_toward(Player.velocity.x, -Player.SPEED/2, slide_friction)

func exit_state():
	sliding = false
	Player.has_dash = true
	Player.particles.emitting = false
	Player.animations.stop()

