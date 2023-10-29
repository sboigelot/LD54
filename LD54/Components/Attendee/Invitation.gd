extends Draggable

export(NodePath) var np__name_label
onready var name_label = get_node(np__name_label) as Label

var attendee

var un_invited_zone
var assigned_seat
var pre_drag_assigned_seat
var dropzone_meta

var move_threshold: float = 5.0
var speed: float = 600.0
var destination: Vector2

var vertical_spacer = 70.0

var allowed_out_of_dropzone_bounds: Rect2

func get_attendee():
	return get_parent().get_parent()

func _ready():
	connect("input_event", self, "_on_Invitation_input_event")
	destination = global_position

func update_attendee(value):
	attendee = value
	name_label.text = attendee.full_name
	update_seat_label()

func update_seat_label():
	if attendee != null:
		$NotePanel/SeatLabel.text = attendee.get_seat_label()

func _process(delta):
	if global_position.distance_to(destination) > move_threshold:
		var direction = global_position.direction_to(destination)
		var velocity = direction * speed

		move_and_collide(velocity * delta)

func on_drag():
	.on_drag()
	destination = global_position
	pre_drag_assigned_seat = assigned_seat
	$NotePanel.rect_rotation = 8
	$NotePanel.rect_scale = Vector2.ONE * 1.1
	
func on_drop():
	.on_drop()
	$NotePanel.rect_rotation = 0
	$NotePanel.rect_scale = Vector2.ONE
	
	move_to_global_position(global_position, false)
	search_drop_zone()
	if assigned_seat == null:
		pervent_draggable_stack()
		
	if not allowed_out_of_dropzone_bounds.has_point(global_position):
		un_invite(true)

func search_drop_zone():
	var drop_zones = get_drop_zones()
	for drop_zone in drop_zones:
#		if not drop_zone.capture(global_position):
		if not drop_zone.bounds_intersect(self):
			continue
			
		if drop_zone.has_free_space(self):
			move_to_drop_zone(drop_zone)
			return
			
		if drop_zone.can_swap(self):
			if pre_drag_assigned_seat != null:
				drop_zone.content.move_to_drop_zone(pre_drag_assigned_seat, true)
			elif un_invited_zone != null:
				drop_zone.content.un_invite(true)
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
	
	if assigned_seat != null:
		assigned_seat.remove_item(self)
		assigned_seat = null
		
	update_seat_label()
	LevelUi.update_attendee_details(attendee)

func move_to_drop_zone(drop_zone, anim:bool=false):

	drop_zone.add_item(self, anim)
	assigned_seat = drop_zone
	
	update_seat_label()
	LevelUi.update_attendee_details(attendee)
	
func _on_Invitation_input_event(viewport, event, shape_idx):
	handle_input_event(event)
	
func un_invite(anim:bool=false):
	assert(un_invited_zone != null)
	move_to_drop_zone(un_invited_zone, anim)
