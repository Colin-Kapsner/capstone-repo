extends CharacterBody2D


var health = 10
# movement
var player_speed = 325.0
const acceleration = 55
const jump_velocity = -450.0
const wall_jump_velocity = -400.0
# wall jump
const wall_jump_knockback = 600
var wall_slide_gravity = 15
# dash
var has_dash = true
var dash_power = 600

@onready var coyote_timer = $CoyoteTimer
@onready var wall_jump_timer = $WallJumpSlowTimer


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _physics_process(delta):
	
	# Move left and right
	var direction = Input.get_axis("Left", "Right")
	move(direction)

	# Add the gravity.
	velocity.y += gravity * delta + 4

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = jump_velocity
	
	# Handle Dash
	if Input.is_action_just_pressed("Dash") and has_dash:
		dash(direction)

	# Handle wall jump
	if (Input.is_action_pressed("Left") or Input.is_action_pressed("Right")) and is_on_wall() and !is_on_floor():
		if velocity.y > 0:
			velocity.y += (-wall_slide_gravity)
		if Input.is_action_just_pressed("Jump"):
			velocity.y = wall_jump_velocity
			while !wall_jump_timer.is_stopped():
				player_speed -= 275
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

func dash(direction):
	if direction:
		velocity.x +=  direction * dash_power

func move(direction):
		if direction:
			velocity.x = move_toward(velocity.x, player_speed * direction, acceleration)
		else:
			velocity.x = move_toward(velocity.x, player_speed * direction, acceleration + 5) #faster deceleration
