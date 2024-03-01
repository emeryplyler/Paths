extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	# key detection?
	call_deferred("reset_scene") # godot gets upset if i don't defer the reset

func reset_scene():
	get_tree().reload_current_scene()
