extends ScrollContainer
   
class_name AutoScrollContainer

var max_scroll_length = 0

onready var scrollbar = self.get_v_scrollbar()

func _ready():
	# auto scrolling
	scrollbar.connect("changed",self,"handle_scrollbar_changed")
	max_scroll_length = scrollbar.max_value
	
func handle_scrollbar_changed():
	if max_scroll_length != scrollbar.max_value:
		max_scroll_length = scrollbar.max_value
		scroll_vertical = max_scroll_length
