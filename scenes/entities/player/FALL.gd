extends "state.gd"


@onready var CoyoteTimer = $CoyoteTimer
@export var coyote_duration = 0.2
var has_jump = true

func enter_state():
	if Player.prev_state == STATES.MOVE or Player.prev_state == STATES.WALLSLIDE or Player.prev_state == STATES.IDLE:
		has_jump = true
		CoyoteTimer.start(coyote_duration)
	else:
		has_jump = false


func update(delta):
	Player.SPEED = 160
	Player.gravity(delta)
	if Player.jump_input_actuation and !Player.has_double_jumped:
		print("returning jump state from fall state")
		Player.has_double_jumped = true
		return STATES.JUMP
	if !Input.is_action_pressed("Slide"):
		player_movement()
	if Player.is_on_floor() and Player.velocity == Vector2.ZERO:
		return STATES.IDLE
	if Player.is_on_floor() and Player.movement_input.x != 0 and !Player.slide_input:
		return STATES.MOVE
	if Player.is_on_floor() and Player.slide_input:
		return $"../SLIDE"
	if Player.dash_input and Player.has_dash:
		return STATES.DASH
	if Player.get_next_to_wall() != null:
		return STATES.WALLSLIDE
	if Player.is_on_floor() and Player.jump_input:
		return STATES.JUMP
	
	return null


func exit_state():
	Player.SPEED = 275

func _on_coyote_timer_timeout():
	has_jump = false
