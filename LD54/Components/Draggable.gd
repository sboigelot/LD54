extends KinematicBody2D

class_name Draggable

signal drag
signal drop
signal select

var dragging = false
var pre_drag_global_position

func _ready():
	add_to_group("draggable")
	connect("drag",self,"on_drag")
	connect("drop",self,"on_drop")

func get_draggables():
	return get_tree().get_nodes_in_group("draggable")

func _process(delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		global_position = Vector2(mousepos.x, mousepos.y)
		
func on_drag():
	pre_drag_global_position = global_position
	dragging = true
	
func on_drop():
	dragging = false

func handle_input_event(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("drag")
			emit_signal("select")
		elif dragging and event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("drop")
		get_tree().set_input_as_handled() 
