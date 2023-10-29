extends Popup

export(Vector2) var mouse_offset = Vector2(20, 20)

func show_tooltip(bbcode_text:String):
	$Node2D/MainContainer/MarginContainer/ContentRichTextBox.bbcode_text = "[color=black]%s[/color]" % bbcode_text
	var mousepos = get_viewport().get_mouse_position()
	show()
	rect_position = mousepos - mouse_offset - get_child(0).get_child(0).rect_size
