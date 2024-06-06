extends Node

@export var black_screen: ColorRect
@export var maze: Node2D
@export var animator: AnimationPlayer
@export var health_bar: TextureRect

var heart_size: int
var disable_health: bool = false

signal game_over

# Called when the node enters the scene tree for the first time.
func _ready():
	maze.player_died.connect(_on_player_died)
	maze.player_respawn.connect(_on_player_respawn)
	maze.berry_pickup.connect(_on_berry_pickup)
	
	# if disablehealth is true, do not display hearts
	await maze.ready # wait for config to load
	disable_health = maze.disable_health
	
	if disable_health:
		health_bar.set_visible(false)
	else:
		health_bar.set_visible(true)
	
	heart_size = 200 # match this to width of heart sprite
	health_bar.size.x = heart_size * maze.player_health # health bar init

func _on_player_died():
	animator.queue("fading_to_black")
	health_bar.size.x = heart_size * maze.player_health
	if maze.player_health <= 0:
		game_over.emit()
	else:
		animator.queue("unfading")
		 # update health bar
	
func _on_player_respawn():
	animator.queue("unfading")
	health_bar.size.x = heart_size * maze.player_health
	
func _on_berry_pickup():
	# insert sound effect here
	health_bar.size.x = heart_size * maze.player_health
