extends GridContainer

@export var glide_control_button: Button
@export var disable_health_button: Button


func _ready():
	set_text_for_key("Glide")
	glide_control_button.set_toggle_mode(true)


func set_text_for_key(action_name: String):
	var action_events = InputMap.action_get_events(action_name)
	var action_keycode = OS.get_keycode_string(action_events[0].physical_keycode)
	
	glide_control_button.text = "%s" % action_keycode


func _on_glide_control_button_toggled(toggled_on):
	if toggled_on: # player just pressed input key
		glide_control_button.text = "Listening..."
		# the actual key will be found within unhandled_key_input
	
	else:
		set_text_for_key("Glide")


func _unhandled_key_input(event):
	rebind_action_key(event)
	glide_control_button.button_pressed = false


func rebind_action_key(event):
	InputMap.action_erase_events("Glide")
	InputMap.action_add_event("Glide", event)
