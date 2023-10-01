extends CanvasLayer

export(NodePath) var np_guess_book
export(NodePath) var np_score_bar

onready var guess_book = get_node(np_guess_book)
onready var score_bar = get_node(np_score_bar) as ProgressBar

var score = 0

func _ready():
	visible = false
	
func clear():
	$LevelUIControl/EndPlanButton.disabled = false
	$LevelUIControl/GuestBook/MarginContainer/VBoxContainer/GuessBookDropZone.clear()
	guess_book.show()
	$LevelUIControl/EventLog.hide()
	score = 0
	
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

func _on_EndPlanButton_pressed():
	if Game.Data.current_level.current_phase == Level.PHASE.PLAN:
		Game.Data.current_level.next_phase()
		guess_book.hide()
		$LevelUIControl/AttendeeDetailWindowDialog.hide()
		$LevelUIControl/EventLog.clear()
		$LevelUIControl/EventLog.show()
		$LevelUIControl/EndPlanButton.disabled = true

func _on_SpeedButton_toggled(button_pressed):
	Engine.time_scale = 5.0 if button_pressed else 1.0

func add_interaction_event(interaction_event):
	$LevelUIControl/EventLog.add_child_for(interaction_event)
	score += interaction_event.impact
	score_bar.value = score
