extends CanvasLayer

export(NodePath) var np_guess_book
export(NodePath) var np_score_bar
export(NodePath) var np_phase_bar
export(NodePath) var np_intro_tuto
export(NodePath) var np_intro_tuto_text

onready var guess_book = get_node(np_guess_book)
onready var score_bar = get_node(np_score_bar) as ProgressBar
onready var phase_bar = get_node(np_phase_bar) as ProgressBar
onready var intro_tuto = get_node(np_intro_tuto) as AcceptDialog
onready var intro_tuto_text = get_node(np_intro_tuto_text) as RichTextLabel

var score = 0

func _ready():
	visible = false
	clear()
	
func clear():
	$LevelUIControl/EndPlanButton.disabled = false
	$LevelUIControl/GuestBook/MarginContainer/VBoxContainer/GuessBookDropZone.clear()
	guess_book.show()
	$LevelUIControl/EventLog.hide()
	score = 0
	update_phase_bar()
	
func show_attendee_details(attendee:Attendee):
	$LevelUIControl/AttendeeDetailWindowDialog.show_detail(attendee, true)
	update_phase_bar()

func update_attendee_details(attendee:Attendee):
	$LevelUIControl/AttendeeDetailWindowDialog.show_detail(attendee, false)
	update_phase_bar()

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
		update_phase_bar()
		
func _on_EndSeatingButton_pressed():
	if Game.Data.current_level.current_phase == Level.PHASE.SEAT:
		Game.Data.current_level.next_phase()
		update_phase_bar()

func _on_EndEatDrinkButton_pressed():
	if Game.Data.current_level.current_phase == Level.PHASE.EATDRKINK:
		Game.Data.current_level.next_phase()
		update_phase_bar()

func _on_EndPartyButton_pressed():
	if Game.Data.current_level.current_phase == Level.PHASE.PARTY:
		end_game()

func end_game():
	pass # todo

func update_phase_bar():
	var phase = 0
	var phase_in_progress = false
	var any_seat_free = true
	var all_attendee_invited = false
	
	if Game.Data != null and Game.Data.current_level != null and is_instance_valid(Game.Data.current_level):
		phase = 				Game.Data.current_level.current_phase
		phase_in_progress = 	Game.Data.current_level.phase_in_progress
		any_seat_free =			Game.Data.current_level.any_seat_free()
		all_attendee_invited = 	Game.Data.current_level.all_attendee_invited()
			
	phase_bar.value = phase
	
	$LevelUIControl/EndPlanButton.visible = phase == Level.PHASE.PLAN
	$LevelUIControl/EndPlanButton.disabled = (phase != Level.PHASE.PLAN or 
												phase_in_progress or 
												(any_seat_free and not all_attendee_invited)
											)
	
	$LevelUIControl/EndSeatingButton.visible = phase == Level.PHASE.SEAT
	$LevelUIControl/EndSeatingButton.disabled = phase != Level.PHASE.SEAT or phase_in_progress
	
	$LevelUIControl/EndEatDrinkButton.visible = phase == Level.PHASE.EATDRKINK
	$LevelUIControl/EndEatDrinkButton.disabled = phase != Level.PHASE.EATDRKINK or phase_in_progress
	
	$LevelUIControl/EndPartyButton.visible = phase == Level.PHASE.PARTY	
	$LevelUIControl/EndPartyButton.disabled = phase != Level.PHASE.PARTY or phase_in_progress

func _on_SpeedButton_toggled(button_pressed):
	Engine.time_scale = 5.0 if button_pressed else 1.0

func add_interaction_event(interaction_event):
	$LevelUIControl/EventLog.add_child_for(interaction_event)
	score += interaction_event.impact
	score_bar.value = score


func _on_IntroTuto_confirmed():
	Game.Data.current_level._on_IntroTuto_confirmed()

func _on_IntroTuto_custom_action(action):
	Game.Data.current_level._on_IntroTuto_custom_action(action)
