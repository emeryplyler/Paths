extends Node

@export var black_screen: ColorRect
@export var maze: Node2D
@export var animator: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	maze.player_died.connect(_on_player_died)

func _on_player_died():
	animator.queue("fading_to_black")
	animator.queue("unfading")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
