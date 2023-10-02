extends MarginContainer

var items: Array

export(NodePath) var np_page_label
onready var ui_page_label = get_node(np_page_label) as Label

export var single_content:bool = false

export var columns: int = 2
export var rows: int = 5
export var current_page = 0

export var seat_name = ""

func clear():
	items.clear()
	arrange_items()

func _ready():
	add_to_group("dropzone")
	arrange_items()

func bounds_intersect(other)->bool:
	var rect_a = Rect2(rect_global_position, rect_size)
	var rect_b = other.get_bounds()
	return rect_a.intersects(rect_b)
			
func has_free_space(requester)->bool:
	return true

func add_item(item, anim:bool=false):
	if not item in items:
		
		if item.pre_drag_assigned_seat != self:
			items.append(item)
		else:
			items.insert(min(item.dropzone_meta, items.size()), item)
			
		item.dropzone_meta = items.find(item)
			
		arrange_items(anim)

func remove_item(item, anim:bool=false):
	if item in items:
		items.erase(item)
		arrange_items(anim)
	
func arrange_items(anim:bool=false):
	
	var max_page = (items.size() / (rows * columns)) + 1
	ui_page_label.text = "%d / %d" % [
		(current_page + 1),
		max_page
	]
	
	var column_index = 0
	var row_index = 0
	
	var page_index = 0
	var min_child_index = (current_page * rows * columns)
	var max_child_index = ((current_page+1) * rows * columns) - 1
	
	var cell_width = rect_size.x / columns
	var cell_height = rect_size.y / rows
	
	var initial_margin = Vector2(cell_width / 2, cell_height / 2)
	
	for child_index in items.size():
		
		var child = items[child_index]
		
#		var local_cell_index = column_index + (row_index * columns) + (page_index * rows * column_index)
		child.visible = min_child_index <= child_index and child_index <= max_child_index
		child.dropzone_meta = child_index
		
		if child.visible:
			var cell_pos = rect_global_position
			
			cell_pos += initial_margin
			cell_pos += Vector2(
					column_index * cell_width,
					row_index * cell_height)
			
			if not anim:
				child.global_position = cell_pos
			child.destination = cell_pos
#		else:
#			child.global_position = Vector2(-200, -200)

		column_index = (column_index + 1) % columns
		if column_index == 0:
			row_index = (row_index + 1) % rows 


func _on_PrevPageButton_pressed():
	SfxManager.play("buttonpress")
	current_page = max(current_page - 1, 0)
	arrange_items()
	
func _on_NextPageButton_pressed():
	SfxManager.play("buttonpress")
	var max_page = (items.size() / (rows * columns)) + 1
	current_page = min(current_page + 1, max_page - 1)
	arrange_items()
