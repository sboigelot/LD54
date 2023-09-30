extends KinematicBody2D

var dragging = false
var host_drop_zone

signal drag
signal drop

func _ready():
	connect("drag",self,"_on_drag")
	connect("drop",self,"_on_drop")
	
func _process(delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		global_position = Vector2(mousepos.x, mousepos.y)

func _on_drag():
	dragging = true
	$NotePanel.rect_rotation = 8
	$NotePanel.rect_scale = Vector2.ONE * 1.1
	
func _on_drop():
	dragging = false
	$NotePanel.rect_rotation = 0
	$NotePanel.rect_scale = Vector2.ONE
	
	var drop_zones = get_drop_zones()
	for drop_zone in drop_zones:
		if not drop_zone.capture(global_position):
			continue
			
		if drop_zone.has_free_space(self):
			move_to_drop_zone(drop_zone)
			return
			
		if not drop_zone.can_swap(self):
			continue
			
		if host_drop_zone != null:
			drop_zone.content.move_to_drop_zone(host_drop_zone)
		move_to_drop_zone(drop_zone)
		return
		
	if host_drop_zone != null:
		if host_drop_zone.single_content:
			host_drop_zone.content = null
		host_drop_zone = null
		
#	 if on top of another dragable --> swap
	
func get_drop_zones():
	return get_tree().get_nodes_in_group("dropzone")

func move_to_drop_zone(drop_zone):
	host_drop_zone = drop_zone
	if host_drop_zone.single_content:
		host_drop_zone.content = self
	global_position = drop_zone.global_position

func _on_Invitation_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("drag")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("drop")
		get_tree().set_input_as_handled() 
