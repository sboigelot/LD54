extends CanvasLayer

func _ready():
	visible = false
	
func show_attendee_details(attendee:Attendee):
	$LevelUIControl/DebugRichTextLabel.bbcode_text = attendee.full_name
	$LevelUIControl/AttendeeDetailWindowDialog.show_detail(attendee)

func _input(event):
	if Input.is_action_just_released("ui_cancel"):
		$LevelUIControl/QuitConfirmationDialog.popup_centered()

func _on_QuitConfirmationDialog_confirmed():
	Game.transition_to_scene("res://Scenes/MainMenu.tscn")
