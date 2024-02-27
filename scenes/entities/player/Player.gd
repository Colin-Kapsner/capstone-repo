extends CharacterBody2D


# player input
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var climb_input = false
var dash_input = false

# player physics
var SPEED = 250.0
var gravity_var = 0
var tile_size = 8
var MAX_JUMP_HEIGHT = tile_size * 6 + .35
var MIN_JUMP_HEIGHT = tile_size * 2 + .35
var jump_duration = 0.3
var max_jump_velocity
var min_jump_velocity
var acceleration = 35
var friction = 33
var last_direction = Vector2.RIGHT
var last_wall_on = Vector2.ZERO
var JUMP_VELOCITY = -500.0
var wall_jump_velocity = -400.0

# mechanics
var has_dash = true

# state stuff
var current_state = null
var prev_state = null

# nodes
@onready var STATES = $STATES
@onready var Raycasts = $Raycasts



func _ready():
	set_velocity_values()
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	prev_state = STATES.IDLE
	current_state = STATES.IDLE


	
func _physics_process(delta):
	player_input()
	change_state(current_state.update(delta))
	$Label.text = str(current_state.get_name)
	move_and_slide()
# TODO PHYSICS PROCESS ENDS HERE

func  set_velocity_values():
	gravity_var = 2 * MAX_JUMP_HEIGHT / pow(jump_duration,2)
	max_jump_velocity = -sqrt(2 * gravity_var * MAX_JUMP_HEIGHT)
	min_jump_velocity = -sqrt(2 * gravity_var * MIN_JUMP_HEIGHT)
	# spring_velocity = -sqrt(2 * gravity_var * SPRING_JUMP_HEIGHT)

func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_var * delta

func change_state(input_state):
	if input_state != null:
		prev_state = current_state
		current_state = input_state
		
		prev_state.exit_state()
		current_state.enter_state()

func player_input():
	movement_input = Vector2.ZERO
	
	if Input.is_action_pressed("MoveRight"):
		movement_input.x += 1
	if Input.is_action_pressed("MoveLeft"):
		movement_input.x -= 1
	if Input.is_action_pressed("MoveUp"):
		movement_input.y -= 1
	if Input.is_action_pressed("MoveDown"):
		movement_input.y += 1
		
	# jump
	if Input.is_action_pressed("Jump"):
		jump_input = true
	else: 
		jump_input = false
	if Input.is_action_just_pressed("Jump"):
		jump_input_actuation = true
	else:
		jump_input_actuation = false

	# climb
	if Input.is_action_pressed("Climb"):
		climb_input = true
	else: 
		climb_input = false

	# dash
	if Input.is_action_just_pressed("Dash"):
		dash_input = true
	else: 
		dash_input = false

func get_next_to_wall():
	for raycast in Raycasts.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.target_position.x > 0:
				return Vector2.RIGHT
			else:
				return Vector2.LEFT
	return null


