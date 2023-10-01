extends CanvasLayer

export(NodePath) var np_guess_book
onready var guess_book = get_node(np_guess_book)

func _ready():
	visible = false
	
func show_attendee_details(attendee:Attendee):
	$LevelUIControl/AttendeeDetailWindowDialog.show_detail(attendee, true)

func update_attendee_details(attendee:Attendee):
	$LevelUIControl/AttendeeDetailWindowDialog.show_detail(attendee, false)

func _input(event):
	if Input.is_action_just_released("ui_cancel"):
		$LevelUIControl/QuitConfirmationDialog.popup_centered()

func _on_QuitConfirmationDialog_confirmed():
	Game.transition_to_scene("res://Scenes/MainMenu.tscn")

func _on_AttendeeDetailWindowDialog_show_tooltip(content):
	$LevelUIControl/TooltipPopup.show_tooltip(content)

func _on_AttendeeDetailWindowDialog_hide_tooltip(content):
	$LevelUIControl/TooltipPopup.hide()
