extends Draggable

var host_drop_zone

var move_threshold: float = 5.0
var speed: float = 500.0
var destination: Vector2

var vertical_spacer = 70.0

func _ready():
	destination = global_position
	update_seat_label()
	
func update_seat_label():
	if host_drop_zone == null:
		$NotePanel/SeatLabel.text = "Not seated"
	elif host_drop_zone.single_content:
		$NotePanel/SeatLabel.text = "%s %s" % [
			host_drop_zone.get_parent().name,
			host_drop_zone.name
		]
	else:
		$NotePanel/SeatLabel.text = "%s" % [
			host_drop_zone.name
		]

func _process(delta):
	if global_position.distance_to(destination) > move_threshold:
		var direction = global_position.direction_to(destination)
		var velocity = direction * speed

		move_and_collide(velocity * delta)

func on_drag():
	.on_drag()
	destination = global_position
	$NotePanel.rect_rotation = 8
	$NotePanel.rect_scale = Vector2.ONE * 1.1
	
func on_drop():
	.on_drop()
	$NotePanel.rect_rotation = 0
	$NotePanel.rect_scale = Vector2.ONE
	
	move_to_global_position(global_position, false)
	search_drop_zone()
	if host_drop_zone == null:
		pervent_draggable_stack()
		
#	TODO: prevent going out of get_viewport_rect()

func search_drop_zone():
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
		else:
			drop_zone.content.move_to_global_position(pre_drag_global_position, true)
		move_to_drop_zone(drop_zone)
		return

func get_drop_zones():
	return get_tree().get_nodes_in_group("dropzone")

func pervent_draggable_stack():
	var draggables = get_draggables()
	for draggable in draggables:
		if draggable == self:
			return
			
		if not _bounds_intersect(draggable):
			continue
		
#		move down
		var pos = Vector2(draggable.global_position.x, draggable.global_position.y + vertical_spacer)
		move_to_global_position(pos, false)
		pervent_draggable_stack()
		return
		
func get_bounds()->Rect2:
	var shape_extends = $CollisionShape2D.shape.extents
	return Rect2(global_position - shape_extends, shape_extends * 2)

func _bounds_intersect(other)->bool:
	var rect_a = get_bounds()
	var rect_b = other.get_bounds()
	return rect_a.intersects(rect_b)
	
func move_to_global_position(pos:Vector2, anim:bool):
	if not anim:
		global_position = pos
	destination = pos
	
	if host_drop_zone != null:
		if host_drop_zone.single_content:
			host_drop_zone.content = null
		elif self in host_drop_zone.items:
			host_drop_zone.items.erase(self)
			reorganize_dropzone_items(host_drop_zone)
		host_drop_zone = null
	update_seat_label()

func move_to_drop_zone(drop_zone, anim:bool=false):
	
	var drop_pos = drop_zone.global_position
	
	host_drop_zone = drop_zone
	if host_drop_zone.single_content:
		host_drop_zone.content = self
	elif not self in host_drop_zone.items:
		drop_pos += Vector2(0, vertical_spacer * host_drop_zone.items.size())
		host_drop_zone.items.append(self)
	update_seat_label()
	
	if not anim:
		global_position = drop_pos
	destination = drop_pos
	
func reorganize_dropzone_items(drop_zone):
	var drop_pos = drop_zone.global_position
	
	for child in drop_zone.items:
		child.global_position = drop_pos
		child.destination = drop_pos
		drop_pos += Vector2(0, vertical_spacer)
	
func _on_Invitation_input_event(viewport, event, shape_idx):
	handle_input_event(event)
