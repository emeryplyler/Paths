extends CanvasLayer

@export var settings_button: Button
var tree
# Called when the node enters the scene tree for the first time.
func _ready():
	tree = get_tree()

func _on_start_button_up():
	#call_deferred("reset_scene")
	tree.change_scene_to_file("res://main_game_scene/root.tscn")

func _on_quit_button_up():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	
func _notification(notif):
	if notif == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # detect requests to quit game
