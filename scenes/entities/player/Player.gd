extends CharacterBody2D

@export var ghost_node : PackedScene

# player input
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var slide_input = false
var dash_input = false

# variables
var SPEED = 300.0
var gravity_var = 0
var tile_size = 8
var MAX_JUMP_HEIGHT = tile_size * 6
var MIN_JUMP_HEIGHT = tile_size * 2
var jump_duration = 0.3
var max_jump_velocity
var min_jump_velocity
var acceleration = 65
var friction = 33
var last_direction = Vector2.RIGHT
var last_wall_on = Vector2.ZERO
var JUMP_VELOCITY = -500.0
var wall_jump_velocity = -400.0

# mechanics
var has_dash = true
var has_jump = true
var was_on_floor = is_on_floor()

# state stuff
var current_state = null
var prev_state = null

# timer stuff
var counting = false
var time_elapsed := 0.0
var counter = 1

# other
@onready var STATES = $STATES
@onready var Raycasts = $Raycasts
@onready var coyote_timer = $Timers/CoyoteTimer
@onready var particles = $GPUParticles2D
@onready var animations = $AnimationPlayer
var delay = 2.5
@onready var Leaderboard_delay = $Timers/Leaderboard_delay


# Always happening
func _process(delta: float) -> void:
	timer_logic(delta)

# When the Player loads in
func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	set_velocity_values()
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	prev_state = STATES.IDLE
	current_state = STATES.IDLE

# While there is physics
func _physics_process(delta):
	cam_physics()
	player_input()
	particle_logic()
	change_state(current_state.update(delta))
	# temporary debug (make label in player.tscn called "current state")
	#$"current state".text = str(current_state.get_name())
	move_and_slide()

# Setting some values (probably not necessary)
func set_velocity_values():
	gravity_var = 3 * MAX_JUMP_HEIGHT / pow(jump_duration,2)
	max_jump_velocity = -sqrt(2 * gravity_var * MAX_JUMP_HEIGHT)
	min_jump_velocity = -sqrt(2 * gravity_var * MIN_JUMP_HEIGHT)
	# spring_velocity = -sqrt(2 * gravity_var * SPRING_JUMP_HEIGHT)

# Gravity...
func gravity(delta):
	if !is_on_floor():
		velocity.y += gravity_var * delta

# Entering, Updating, and Exiting states
func change_state(input_state):
	if input_state != null:
		prev_state = current_state
		current_state = input_state
		
		prev_state.exit_state()
		current_state.enter_state()

# Recording all player input
func player_input():
	movement_input = Vector2.ZERO

	if was_on_floor && !is_on_floor():
		coyote_timer.start()

	# Menu (Esc)
	if Input.is_action_just_pressed("Menu"):
		get_tree().change_scene_to_file("res://menu.tscn")
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)


	# Restart (R)
	if Input.is_action_just_pressed("Restart") and Leaderboard_delay.is_stopped():
		position.x = 0
		position.y = 0
		velocity = Vector2.ZERO
		time_elapsed = 0.0
		counting = false

	# Movement (WASD)
	if Input.is_action_pressed("MoveRight"):
		movement_input.x += 1
	if Input.is_action_pressed("MoveLeft"):
		movement_input.x -= 1
	if Input.is_action_pressed("MoveUp"):
		movement_input.y -= 1
	if Input.is_action_pressed("MoveDown"):
		movement_input.y += 1

	# jump (Spacebar)
	if Input.is_action_pressed("Jump"):
		jump_input = true
	else: 
		jump_input = false
	if Input.is_action_just_pressed("Jump"):
		jump_input_actuation = true
	else:
		jump_input_actuation = false

	# Slide (S)
	if Input.is_action_pressed("Slide"):
		slide_input = true
	else: 
		slide_input = false

	# Dash (P)
	if Input.is_action_just_pressed("Dash"):
		dash_input = true
	else: 
		dash_input = false

# Using raycasts to determine if the player is next to a wall
func get_next_to_wall():
	for raycast in Raycasts.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.target_position.x > 0:
				return Vector2.RIGHT
			else:
				return Vector2.LEFT
	return null

# Camera functionality
func cam_physics():
	if velocity.x >= 450:
		$Camera2D.offset.x = move_toward($Camera2D.offset.x, 450, 4)
	elif velocity.x <= -450:
		$Camera2D.offset.x = move_toward($Camera2D.offset.x, -300, 3)
	else:
		$Camera2D.offset.x = move_toward($Camera2D.offset.x, 125, 1.5)

# This is all timer stuff
func _on_start_timer_body_entered(body):
	time_elapsed = 0
	counting = true
func _on_end_timer_body_entered(body):
	counting = false
	if Leaderboard_delay.is_stopped():
		$"../HUD/Control/Time".scale *=  2
		$"../HUD/Control/Time".position = get_viewport_rect().size/2
		$"../HUD/Control/Time".position.x -= 100
		$"../HUD/Control/Time".position.y -= 100
		Leaderboard_delay.start(delay)
func _on_leaderboard_delay_timeout():
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")
func timer_logic(delta: float):
	if counting:
		time_elapsed += delta
		# Concatenating for glitch
		$"../HUD/Control/Time".text = " " + str(time_elapsed).pad_decimals(3)
	else:
		pass



# Dash particle logic
func particle_logic():
	if is_on_floor():
		particles.position.y = 10
	else:
		particles.position.y = 0

# Reset logic
func _on_reset_body_entered(body):
	has_dash = true
	has_jump = true


