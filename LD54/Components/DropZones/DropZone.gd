extends Node2D

class_name DropZone

export var single_content:bool = true

export var seat_name = "Uninvited"

var content
var items: Array

var vertical_spacer = 70.0

func _ready():
	add_to_group("dropzone")

func capture(position)->bool:
	return (position.x >= $DropPanel.rect_global_position.x and
			position.y >= $DropPanel.rect_global_position.y and
			position.x <= $DropPanel.rect_global_position.x + $DropPanel.rect_size.x and
			position.y <= $DropPanel.rect_global_position.y + $DropPanel.rect_size.y)
			
func bounds_intersect(other)->bool:
	var rect_a = Rect2($DropPanel.rect_global_position, $DropPanel.rect_size)
	var rect_b = other.get_bounds()
	return rect_a.intersects(rect_b)
			
func has_free_space(requester)->bool:
	return not single_content or content == null
	
func can_swap(requester)->bool:
	return content != null

func add_item(item, anim:bool=false):
	if single_content:
		content = item
		arrange_content(anim)
	elif not item in items:
		items.append(item)
		arrange_items(anim)

func remove_item(item, anim:bool=false):
	if single_content:
		content = null
	elif item in items:
		items.erase(item)
		arrange_items(anim)

func arrange_content(anim:bool=false):
	var drop_pos = global_position
	if not anim:
		content.global_position = drop_pos
	content.destination = drop_pos
	
func arrange_items(anim:bool=false):
	var drop_pos = global_position
	
	for child in items:
		if not anim:
			child.global_position = drop_pos
		child.destination = drop_pos
		drop_pos += Vector2(0, vertical_spacer)
