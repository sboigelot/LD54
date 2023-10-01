extends Popup

signal show_tooltip(content)
signal hide_tooltip(content)

export(NodePath) var np_attendee_visual
export(NodePath) var np_name_label
export(NodePath) var np_seat_label
export(NodePath) var np_traits_rich_text_label

onready var ui_attendee_visual = get_node(np_attendee_visual)
onready var ui_name_label = get_node(np_name_label) as Label
onready var ui_seat_label = get_node(np_seat_label) as Label
onready var ui_traits_rich_text_label = get_node(np_traits_rich_text_label) as RichTextLabel

var dragging = false
var drag_offset:Vector2

func show_detail(attendee:Attendee, show:bool):
	ui_attendee_visual.update_sprites(attendee)
	ui_name_label.text = attendee.full_name
	ui_seat_label.text = attendee.get_seat_label()
	
	var traits_str = []
	for trait in attendee.traits:
		traits_str.append("[url=%s][color=%s]%s[/color][/url]" % [
			trait.get_description(),
			trait.get_color(),
			trait.get_display_name()
		])
	var desc = "[center][color=black]%s[/color][/center]" % [ PoolStringArray(traits_str).join(", ") ]
	ui_traits_rich_text_label.bbcode_text = desc
	
	if show:
		show()

func _on_TextureButton_pressed():
	hide()

func _process(delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		rect_position = mousepos - drag_offset
		
func _on_MainContainer_gui_input(event):
	if mouse_default_cursor_shape != CURSOR_POINTING_HAND:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			dragging = true
			var mousepos = get_viewport().get_mouse_position()
			drag_offset = mousepos - rect_position
			rect_rotation =  -4
			rect_scale = Vector2.ONE * 1.1
			ui_attendee_visual.rotation_degrees =  -4
			ui_attendee_visual.scale = Vector2.ONE * 2.1
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			dragging = false
			rect_rotation =  0
			rect_scale = Vector2.ONE
			ui_attendee_visual.rotation_degrees =  0
			ui_attendee_visual.scale = Vector2.ONE * 2

func _on_TraitsRichTextLabel_meta_hover_started(meta):
	emit_signal("show_tooltip", meta)

func _on_TraitsRichTextLabel_meta_hover_ended(meta):
	emit_signal("hide_tooltip", meta)
