extends WindowDialog

func show_detail(attendee:Attendee):
	$MarginContainer/VBoxContainer/NameLabel.text = attendee.full_name
	$MarginContainer/VBoxContainer/CenterContainer/AttendeeVisual.update_sprites(attendee)
	show()
