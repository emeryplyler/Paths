extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var WALL_PUSH_VELOCITY = 0

var facing_left: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("Jump") and is_on_wall() and not is_on_floor():
		velocity.y = JUMP_VELOCITY
		if facing_left:
			velocity.x = WALL_PUSH_VELOCITY
		else:
			velocity.x = -WALL_PUSH_VELOCITY
		print(velocity)
		print(facing_left)
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var lr = Input.get_axis("Left", "Right")
	#var ud = Input.get_axis("Up", "Down")
	if lr:
		velocity.x = lr * SPEED
		if lr < 0 and not facing_left:
			flip()
		elif lr > 0 and facing_left:
			flip()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#if ud:
		#velocity.y = ud * SPEED
	#else:
		#velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func flip():
	facing_left = not facing_left
	# flip sprite around
