extends CharacterBody2D





var health = 10

# movement
var SPEED = 325.0
const acceleration = 55
const JUMP_VELOCITY = -450.0
const wall_jump_velocity = -400.0

# wall jump
const wall_jump_knockback = 600
var wall_slide_gravity = 15

# dash
var has_dash = true
var dash_power = 600

# player input
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var climb_input = false
var dash_input = false

# state stuff
var current_state = null
var prev_state = null
@onready var STATES = $STATES

@onready var coyote_timer = $CoyoteTimer
@onready var wall_jump_timer = $WallJumpSlowTimer




func _ready():
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	prev_state = STATES.IDLE
	current_state = STATES.IDLE

func _physics_process(delta):
	# TODO VIDEO STUFF IN HERE ⬇
	player_input()
	change_state(current_state.update(delta))
	$Label.text = str(current_state.get_name)
	move_and_slide()
	
	
	# TODO VIDEO STUFF IN HERE ⬆
	# Move left and right
	var direction = Input.get_axis("Left", "Right")
	move(direction)

	# Add the gravity.
	velocity.y += gravity * delta + 4

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
	
	# Handle Dash
	if Input.is_action_just_pressed("Dash") and has_dash:
		dash(direction)

	# Handle wall jump
	if (Input.is_action_pressed("MoveLeft") or Input.is_action_pressed("MoveRight")) and is_on_wall() and !is_on_floor():
		if velocity.y > 0:
			velocity.y += (-wall_slide_gravity)
		if Input.is_action_just_pressed("Jump"):
			velocity.y = wall_jump_velocity
			while !wall_jump_timer.is_stopped():
				SPEED -= 275
			velocity.x = wall_jump_knockback * -direction
	
	var was_on_floor = is_on_floor()
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
		
	var was_on_wall = is_on_wall()
	if was_on_wall && !is_on_wall():
		wall_jump_timer.start()
	
	# Fall through platform
	if Input.is_action_pressed("Down") && is_on_floor():
		position.y += 1
		
	move_and_slide()

	# Health
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")

# TODO PHYSICS PROCESS ENDS HERE

func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func dash(direction):
	if direction:
		velocity.x +=  direction * dash_power

func move(direction):
		if direction:
			velocity.x = move_toward(velocity.x, SPEED * direction, acceleration)
		else:
			velocity.x = move_toward(velocity.x, SPEED * direction, acceleration + 5) #faster deceleration

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
	if Input.is_action_pressed("Dash"):
		dash_input = true
	else: 
		dash_input = false




