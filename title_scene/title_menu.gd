extends CanvasLayer

@export var settings_button: Button
@export var settings_menu: Control
@export var darken_bg: ColorRect
@export var menu_script: GridContainer

# options in the settings menu
@export var volume_slider: Slider
@export var disable_health_button: CheckButton 
@export var glide_control: Button

var config = ConfigFile.new() # save settings to config

var tree
# Called when the node enters the scene tree for the first time.
func _ready():
	tree = get_tree()
	settings_menu.set_visible(false)
	darken_bg.set_visible(false)
	read_from_config() # read from config

func _on_start_button_up():
	write_to_config() # write to cfg file
	tree.change_scene_to_file("res://main_game_scene/root.tscn")

func _on_quit_button_up():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	
func _notification(notif):
	if notif == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # detect requests to quit game

func _on_settings_button_up():
	settings_menu.set_visible(true)
	darken_bg.set_visible(true)


func _on_back_button_up():
	settings_menu.set_visible(false)
	darken_bg.set_visible(false)


func read_from_config():
	var err = config.load("user://settings.cfg")
	if err != OK:
		return # file didn't load right
	
	volume_slider.value = config.get_value("Settings", "Volume", 50) # 3rd value is default
	disable_health_button.button_pressed = config.get_value("Settings", "DisableHealth", false)
	var new_glide_control = config.get_value("Settings", "GlideControl", "Shift")
	if new_glide_control != glide_control.text:
		var e = InputEventKey.new() # temporary new event just to set the keybind
		e.keycode = OS.find_keycode_from_string(new_glide_control)
		menu_script.rebind_action_key(e) # change controls using settings script
		glide_control.text = new_glide_control # update button text


func write_to_config():
	config.set_value("Settings", "Volume", volume_slider.value)
	config.set_value("Settings", "DisableHealth", disable_health_button.button_pressed)
	config.set_value("Settings", "GlideControl", glide_control.text)
	
	config.save("user://settings.cfg") # actually write changes to file
