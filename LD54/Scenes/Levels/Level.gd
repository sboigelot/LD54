extends Node2D

class_name Level

signal new_phase
enum PHASE {PLAN, SEAT, EATDRKINK, PARTY}
var current_phase = PHASE.PLAN
var phase_in_progress = false

var phase_interaction_events = {
	PHASE.SEAT: [],
	PHASE.EATDRKINK: [],
	PHASE.PARTY: []
} 

export(NodePath) var np_groom
export(NodePath) var np_bride
export(NodePath) var np_meet_groom_pos2d
export(NodePath) var np_meet_bride_pos2d
export(NodePath) var np_attendee_start_pos2d
export(NodePath) var np_bar_pos2d
export(NodePath) var np_buffet_pos2d
export(NodePath) var np_dancefloor_pos2d

onready var groom = get_node(np_groom)
onready var bride = get_node(np_bride)
onready var meet_groom_pos2d = get_node(np_meet_groom_pos2d) as Position2D
onready var meet_bride_pos2d = get_node(np_meet_bride_pos2d) as Position2D
onready var attendee_start_pos2D = get_node(np_attendee_start_pos2d) as Position2D
onready var bar_pos2d = get_node(np_bar_pos2d) as Position2D
onready var buffet_pos2d = get_node(np_buffet_pos2d) as Position2D
onready var dancefloor_pos2d = get_node(np_dancefloor_pos2d) as Position2D

var tables: Array
var skip_tutorial:bool = false
var tuto_index = 0

func _ready():
	Game.Data.current_level = self
	LevelUi.score = 0
	LevelUi.update_score_bar()
	LevelUi.show()
	un_invite_all()
	play_current_phase() #hide the Attendee visuals and show invitations
#	$HonorTable/Groom.show_only_attendee_visual()
#	$HonorTable/Bride.show_only_attendee_visual()

	LevelUi.intro_skip_button.visible = not Game.join_the_dark_side
	if Game.join_the_dark_side:
		skip_tutorial = true
		LevelUi.intro_tuto_text.bbcode_text = "[center][img]res://Images/Avatars/ex.svg[/img]\n\nORGANISER! I NEED YOUR HELP!\n\nMy soulmate and I broke up two years ago but it was a mistake!\n\nNow he will marry a ****!\n\nMake sur to make their wedding a BIG FAILURE![/center]"

	LevelUi.intro_tuto.popup_centered()

func _on_IntroTuto_custom_action(action):
	if action == "skip_tutorial":
		skip_tutorial = true
	LevelUi.intro_tuto.hide()
		
func _on_IntroTuto_confirmed():
	if skip_tutorial:
		return
		
	tuto_index += 1
	
	if tuto_index == 1:
		LevelUi.intro_tuto_text.bbcode_text = "\n\nDrag and drop guest from the Guest Book to seat.\n\nClick on a guest to show more info.\n\nYou can learn more about guest traits by pointing your mouse cursor over them.\n\nYour goal is to match people with the same interest at the same table, avoid fights and follow the desire of each guest."
		LevelUi.intro_tuto.popup_centered_minsize(Vector2.ZERO)
		
	if tuto_index == 2:
		LevelUi.intro_tuto_text.bbcode_text = "\n\nGreat, all seats are full!\n\nYou can start the wedding with the play button on the bottom left of the screen when you are ready."
		
	if tuto_index == 3:
		LevelUi.intro_tuto_text.bbcode_text = "\n\nEveryone is seated, you can start the next phase of the wedding by sending everyone to buffet with the play button when you are ready."
		
	if tuto_index == 4:
		LevelUi.intro_tuto_text.bbcode_text = "\n\nThat went well! Time to start party! (same button again)"
		
	if tuto_index == 5:
		LevelUi.intro_tuto_text.bbcode_text = "\n\nThis is the end,\n\nfinish the wedding and check your score! (same button again)"
		
func register_table(table):
	if not table in tables:
		tables.append(table)

func any_seat_free()->bool:
	for table in tables:
		if table.any_seat_free():
			return true
	
	if not skip_tutorial and tuto_index == 2:
		LevelUi.intro_tuto.popup_centered_minsize(Vector2.ZERO)
		
	return false
	
func all_attendee_invited()->bool:
	for attendee in $Attendees.get_children():
		if not attendee.is_invited():
			return false
			
	if not skip_tutorial and tuto_index == 2:
		LevelUi.intro_tuto.popup_centered_minsize(Vector2.ZERO)
		
	return true

func everyone_dancing()->bool:
	for attendee in $Attendees.get_children():
		if not attendee.is_invited():
			continue
		if attendee.go_dance_at_party and not attendee.dancing:
			return false
	return true

func has_interaction(attendee1, trait1, attendee2, trait2)->bool:
	if not phase_interaction_events.has(current_phase):
		return false
		
	for old_event in phase_interaction_events[current_phase]:
		if (old_event.attendee1 == attendee1 and
			old_event.trait1 == trait1 and
			old_event.attendee2 == attendee2 and
			old_event.trait2 == trait2):
			return true
			
		if (old_event.attendee1 == attendee2 and
			old_event.trait1 == trait2 and
			old_event.attendee2 == attendee1 and
			old_event.trait2 == trait1):
			return true
			
	return false
	
func add_interaction_event(interaction_event):
	print(interaction_event.description)
	phase_interaction_events[current_phase].append(interaction_event)
	LevelUi.add_interaction_event(interaction_event)
	
func un_invite_all():
	for attendee in $Attendees.get_children():
		var venue_floor_center = $Venue/Area2D/VenueFloor.global_position
		var venue_floor_shape = $Venue/Area2D/VenueFloor.shape as RectangleShape2D
		attendee.un_invite(LevelUi.guess_dropzone, 
			Rect2(venue_floor_center.x - venue_floor_shape.extents.x,
				venue_floor_center.y - venue_floor_shape.extents.y,
				venue_floor_shape.extents.x * 2,
				venue_floor_shape.extents.y * 2))
		
	$Disabled.queue_free()

func any_attendee_in_phase()->bool:
	for attendee in $Attendees.get_children():
		if not attendee.phase_completed:
			return true
	return false

func play_current_phase():
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
#	start yield for all attendee ?
#	for each attendee with x sec delay between each
	var delay_between_attendee = 1.1 if current_phase != PHASE.PLAN else 0
	var current_delay = 0.0
	
	for attendee in $Attendees.get_children():
		attendee.on_new_phase(current_delay)
		if attendee.is_invited():
			current_delay += delay_between_attendee
		elif current_phase != PHASE.PLAN:
			attendee.queue_free()
			
	while(any_attendee_in_phase()):
		yield(get_tree().create_timer(0.5), "timeout")
		
	print("Phase %s completed" % PHASE.keys()[current_phase])
	
	phase_in_progress = false
	if current_phase == PHASE.PLAN:
		LevelUi.guess_dropzone.arrange_items()
	LevelUi.update_phase_bar()
	
	if not skip_tutorial:
		LevelUi.intro_tuto.popup_centered_minsize(Vector2.ZERO)
		
	
func next_phase():
	match current_phase:
		PHASE.PLAN:
			current_phase = PHASE.SEAT
			phase_in_progress = true
			play_current_phase()
			return
		PHASE.SEAT:
			current_phase = PHASE.EATDRKINK
			phase_in_progress = true
			play_current_phase()
			return
		PHASE.EATDRKINK:
			current_phase = PHASE.PARTY
			phase_in_progress = true
			play_current_phase()
			return

