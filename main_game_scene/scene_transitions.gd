extends Node

@export var black_screen: ColorRect
@export var maze: Node2D
@export var animator: AnimationPlayer
@export var health_bar: TextureRect

var heart_size: int

# Called when the node enters the scene tree for the first time.
func _ready():
	maze.player_died.connect(_on_player_died)
	heart_size = 200
	health_bar.size.x = heart_size * maze.player_health
	# change health_bar.size.x to heart_size * health (3?)

func _on_player_died():
	animator.queue("fading_to_black")
	animator.queue("unfading")
	health_bar.size.x = heart_size * maze.player_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
