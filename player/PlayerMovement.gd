extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var WALL_PUSH_VELOCITY = 0
@export var sprite: Sprite2D
@export var timer: Timer
@export var max_fall_speed: float

@export var anim_tree: AnimationTree
enum anim_states {
	idle, running, jumping, falling, gliding, wallclinging, walljumping
}
var current_anim_state

var facing_left: bool = false
var is_wall_pushing: bool = false
var has_double_jumped: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var glide_t: float = 0 # used for lerping glide

func _ready():
	anim_tree.active = true 
	current_anim_state = anim_states.idle

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		glide_t += 0.01
		glide_t = clampf(glide_t, 0, 1)
		if Input.is_action_just_pressed("Glide"):
			glide_t = 0
			
		if Input.is_action_pressed("Glide"):
			velocity.y = lerpf(velocity.y, max_fall_speed, glide_t)
			
		else:
			velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			has_double_jumped = false
			velocity.y = JUMP_VELOCITY
			
		elif is_on_wall() and not is_on_floor():
			velocity.y = JUMP_VELOCITY
			if facing_left:
				velocity.x = WALL_PUSH_VELOCITY
			else:
				velocity.x = -WALL_PUSH_VELOCITY
			flip()

			is_wall_pushing = true
			has_double_jumped = false
			timer.start()
			
		elif not has_double_jumped and not is_on_floor():
			velocity.y = JUMP_VELOCITY
			has_double_jumped = true
		
		
	if not is_wall_pushing: # player has not just wall jumped
	# Get the input direction and handle the movement/deceleration
		var lr = Input.get_axis("Left", "Right")
		#var ud = Input.get_axis("Up", "Down")
		if lr:
			velocity.x = lr * SPEED
			if lr < 0 and not facing_left:
				flip()
			elif lr > 0 and facing_left:
				flip()
			if is_on_floor():
				current_anim_state = anim_states.running # player is moving and on the floor
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				current_anim_state = anim_states.idle # player not moving and on floor

	move_and_slide()
	update_anim_params()

func update_anim_params():
	if current_anim_state == anim_states.idle:
		anim_tree.set("parameters/movement/transition_request", "idle")
		
	else:
		if current_anim_state == anim_states.running:
			anim_tree.set("parameters/movement/transition_request", "run")

func flip():
	facing_left = not facing_left
	# flip sprite around
	sprite.scale.x *= -1


func _on_wall_jump_timer_timeout():
	is_wall_pushing = false
