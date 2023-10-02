extends Node

export(PackedScene) var game_data_scene
var Data: GameData

var current_level_path

export(PoolColorArray) var transition_colors

func _ready():
#	new_game() # for debug singl components
	randomize()

func new_game():
	if Data != null:
		Data.queue_free()
		
	LevelUi.clear()
	Data = game_data_scene.instance()
	add_child(Data)
	
func transition_to_scene(scene_path):
	var textures = [
		load("res://addons/node_library/assets/transition-texture.png"),
		load("res://addons/node_library/assets/screen-transition-alternate.png"),
		load("res://addons/node_library/assets/middle_strip.png")
	]

	var color_index = randi() % transition_colors.size()
	var texture_index = randi() % textures.size()
	ScreenTransition.set_transition_color(transition_colors[color_index])
	ScreenTransition.set_transition_texture(textures[texture_index])
	ScreenTransition.transition_to_scene(scene_path)

func _input(_event):			
	if Input.is_action_just_released("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
