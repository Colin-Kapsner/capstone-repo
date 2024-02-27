extends "state.gd"

var dash_direction = Vector2.ZERO
var dashing = false
@export var dash_speed = 400
@export var dash_duration = .2
@onready var DashDuration_timer = $DashDuration


func update(delta):
	if !dashing:
		return STATES.FALL
	if Player.get_next_to_wall() != null:
		return STATES.WALLSLIDE
	if dashing and Player.is_on_floor():
		if Input.is_action_pressed("Slide"):
			return $"../SLIDE"
	if Player.is_on_floor() and Input.is_action_pressed("Jump"):
		return STATES.JUMP
	return null
func enter_state():
	dashing = true
	Player.has_dash = false
	DashDuration_timer.start(dash_duration)
	if Player.movement_input != Vector2.ZERO:
		dash_direction = Player.movement_input
	else:
		dash_direction = Player.last_direction
	Player.velocity = dash_direction.normalized() * dash_speed
func exit_state():
	dashing = false
	pass

func _on_timer_timeout():
	dashing = false
	pass # Replace with function body.
