extends CanvasLayer

func _ready():
	visible = false
	
func show_attendee_details(attendee:Attendee):
	$LevelUIControl/DebugRichTextLabel.bbcode_text = attendee.full_name
	pass
