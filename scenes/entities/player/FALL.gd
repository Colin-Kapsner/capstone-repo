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
	Player.gravity(delta)
	player_movement()
	if Player.is_on_floor() and Player.velocity == Vector2.ZERO:
		return STATES.IDLE
	if Player.is_on_floor() and Player.movement_input.x != 0 and !Input.is_action_pressed("Slide"):
		return STATES.MOVE
	if Player.is_on_floor() and Input.is_action_pressed("Slide"):
		return $"../SLIDE"
	if Player.dash_input and Player.has_dash:
		return STATES.DASH
	if Player.get_next_to_wall() != null:
		return STATES.WALLSLIDE
	if Player.jump_input_actuation and has_jump:
		return STATES.JUMP
	return null


func _on_coyote_timer_timeout():
	has_jump = false
