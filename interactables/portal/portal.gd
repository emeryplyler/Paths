extends Node2D

signal player_entered_portal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_2d_body_entered(_body):
	# key detection?
	player_entered_portal.emit()
	#call_deferred("reset_scene") # godot gets upset if i don't defer the reset

#func reset_scene():
	#get_tree().reload_current_scene()
