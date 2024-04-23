extends "state.gd"

var is_player_movement = false
@onready var CoyoteTimer = $"../../Timers/CoyoteTimer"
@export var coyote_duration = 0.2

func enter_state():
	if Player.prev_state == STATES.MOVE or Player.prev_state == STATES.WALLSLIDE or Player.prev_state == STATES.IDLE:
		Player.has_jump = true
		CoyoteTimer.start(coyote_duration)
	else:
		pass


func update(delta):
	Player.SPEED = 200
	Player.gravity(delta)
	if is_player_movement:
		player_movement()
	if Player.jump_input_actuation and Player.has_jump:
		Player.has_jump = false
		return STATES.JUMP
	if !Player.slide_input:
		is_player_movement = true
	if Player.is_on_floor() and Player.velocity == Vector2.ZERO:
		return STATES.IDLE
	if Player.is_on_floor() and (Player.movement_input.x != 0 or !Player.slide_input):
		return STATES.MOVE
	if Player.is_on_floor() and Player.slide_input:
		return $"../SLIDE"
	if Player.dash_input and Player.has_dash:
		return STATES.DASH
	if Player.get_next_to_wall() != null:
		return STATES.WALLSLIDE
	return null


func exit_state():
	Player.SPEED = 275
	is_player_movement = false

func _on_coyote_timer_timeout():
	Player.has_jump = false
