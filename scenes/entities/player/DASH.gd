extends "state.gd"

var dash_direction = Vector2.ZERO
var dashing = false
var dash_slide_boost = 100
@export var dash_speed = 400
@export var dash_duration = .2
@onready var DashDuration_timer = $DashDuration

func enter_state():
	dashing = true
	Player.has_dash = false
	Player.particles.emitting = true
	DashDuration_timer.start(dash_duration)
	if Player.movement_input != Vector2.ZERO:
		dash_direction.x = Player.movement_input.x
	else:
		dash_direction.x = Player.last_direction.x
	Player.velocity.y = 0
	Player.velocity.x = dash_direction.x * dash_speed

func update(delta):
	if !dashing:
		Player.velocity.x = 0
		return STATES.FALL
	if Player.get_next_to_wall() != null:
		return STATES.WALLSLIDE
	if dashing and Player.is_on_floor():
		if Player.slide_input:
			Player.velocity.x += dash_direction.x * dash_slide_boost
			return $"../SLIDE"
	return null

func exit_state():
	dashing = false
	Player.particles.emitting = false
	pass

func _on_timer_timeout():
	dashing = false
