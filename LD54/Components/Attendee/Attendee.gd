extends Node2D

class_name Attendee

export(String) var full_name

export(Texture) var hair_texture
export(Texture) var eyes_texture
export(Texture) var face_texture
export(Texture) var body_texture

var traits: Array

var seated: bool = false
var dancing: bool = false
var phase_completed: bool = false

export(bool) var go_drink_at_party = false
export(bool) var go_dance_at_party = true

func _ready():
	$AttendeeVisual.update_sprites(self)
	$CanvasLayer/Invitation.update_attendee(self)

func show_only_invitation():
	$AttendeeVisual.visible = false
	$CanvasLayer/Invitation.visible = true
	
func show_only_attendee_visual():
	$AttendeeVisual.visible = true
	$CanvasLayer/Invitation.visible = false

func is_invited()->bool:
	return get_seat() != null and get_seat().single_content
	
func on_new_phase(delay):
	phase_completed = false
	match Game.Data.current_level.current_phase:
		Level.PHASE.PLAN:
			show_only_invitation()
			phase_completed = true
			
		Level.PHASE.SEAT:
			show_only_attendee_visual()
			start_phase_seat(delay)
			
		Level.PHASE.EATDRKINK:
			show_only_attendee_visual()
			start_phase_eatdrink(delay)
			
		Level.PHASE.PARTY:
			show_only_attendee_visual()
			start_phase_party(delay)

func start_phase_seat(delay):
	
	var invited = is_invited()
	
	seated = false
	$AttendeeVisual.visible = invited
	$AttendeeVisual.global_position = Game.Data.current_level.attendee_start_pos2D.global_position
	
	if not invited:
		return
			
	if delay > 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	
#	Attendee go to bride/groom
	var bride_position = Game.Data.current_level.meet_bride_pos2d.global_position
	$AttendeeVisual.start_move_to(bride_position)
	yield($AttendeeVisual, "move_completed")
	
#	Attendee interract with groom
	yield(interact_with_bride(), "completed")

#	Attendee go to groom
	var groom_position = Game.Data.current_level.meet_groom_pos2d.global_position
	$AttendeeVisual.start_move_to(groom_position)
	yield($AttendeeVisual, "move_completed")
	
#	Attendee interract with groom
	yield(interact_with_groom(), "completed")
	
#	Attendee go to seat
	var seat_position = get_seat().global_position
	$AttendeeVisual.start_move_to(seat_position)
	yield($AttendeeVisual, "move_completed")
	
#	Attendee interact with seat
	yield(interact_with_seat_position(get_seat()), "completed")	
	seated = true

#	Attendee wait for everyone at table
	var table = get_seat().get_parent()
	while not table.everyone_seated():
		yield(get_tree().create_timer(0.5), "timeout")
		
#	Attendee waits for their turn to speak
	while table.current_speaker != null:
		yield(get_tree().create_timer(0.5), "timeout")
	table.current_speaker = self
	
#	Attendee interract at table
	var attendees = table.get_attendees()
	for other_attendee in attendees:
		if self == other_attendee:
			continue
		yield(interact_with_attendee(other_attendee), "completed")
	
	table.current_speaker = null
	phase_completed = true

func start_phase_eatdrink(delay):
	
	var invited = is_invited()
	
	seated = false
	
	if not invited:
		return
			
	if delay > 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	
#	Attendee go to buffet location
	var buffet_position = Game.Data.current_level.buffet_pos2d.global_position
	$AttendeeVisual.start_move_to(buffet_position)
	yield($AttendeeVisual, "move_completed")
	
#	Attendee interact with buffet location
	yield(interact_with_buffet(get_seat()), "completed")
	
#	Attendee go to seat
	var seat_position = get_seat().global_position
	$AttendeeVisual.start_move_to(seat_position)
	yield($AttendeeVisual, "move_completed")
	
#	Attendee go to bar location
	var bar_position = Game.Data.current_level.bar_pos2d.global_position
	$AttendeeVisual.start_move_to(bar_position)
	yield($AttendeeVisual, "move_completed")
	
#	Attendee interact with bar location
	yield(interact_with_bar(get_seat()), "completed")
	
#	Attendee go to seat
	$AttendeeVisual.start_move_to(seat_position)
	yield($AttendeeVisual, "move_completed")
	
#	Attendee interact with seat
#	yield(interact_with_seat_position(get_seat()), "completed")	
	seated = true

#	Attendee wait for everyone at table
	var table = get_seat().get_parent()
	while not table.everyone_seated():
		yield(get_tree().create_timer(0.5), "timeout")
		
#	Attendee waits for their turn to speak
	while table.current_speaker != null:
		yield(get_tree().create_timer(0.5), "timeout")
	table.current_speaker = self
	
#	Attendee interract at table
	var attendees = table.get_attendees()
	for other_attendee in attendees:
		if self == other_attendee:
			continue
		yield(interact_with_attendee(other_attendee), "completed")
	
	table.current_speaker = null
	phase_completed = true


func start_phase_party(delay):
	
	var invited = is_invited()
	
	seated = false
	
	if not invited:
		return
			
	if delay > 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	
	if go_drink_at_party:		
	#	Attendee go to bar location
		var bar_position = Game.Data.current_level.bar_pos2d.global_position
		$AttendeeVisual.start_move_to(bar_position)
		yield($AttendeeVisual, "move_completed")
		
	#	Attendee interact with bar location
		yield(interact_with_bar(get_seat()), "completed")
		
	if go_dance_at_party:
	#	Attendee go to dancefloor location
		var dancefloor_position = Game.Data.current_level.dancefloor_pos2d.global_position
		dancefloor_position += Vector2(
			rand_range(-200.0, 200.0),
			rand_range(-100.0, 100.0)
		)
		$AttendeeVisual.start_move_to(dancefloor_position)
		yield($AttendeeVisual, "move_completed")
		
		dancing = true
	#	wait for every dancer on the dance floor
		while not Game.Data.current_level.everyone_dancing():
			yield(get_tree().create_timer(0.5), "timeout")
		
	#	Attendee interact with dancefloor location
#	 yield dance animation
		yield(get_tree().create_timer(0.5), "timeout")
		dancing = false
		yield(interact_with_dancefloor(get_seat()), "completed")
	
#	Attendee go to seat
	var seat_position = get_seat().global_position
	$AttendeeVisual.start_move_to(seat_position)
	yield($AttendeeVisual, "move_completed")
	
#	Attendee interact with seat
#	yield(interact_with_seat_position(get_seat()), "completed")	
	seated = true

#	Attendee wait for everyone at table
	var table = get_seat().get_parent()
	while not table.everyone_seated():
		yield(get_tree().create_timer(0.5), "timeout")
		
#	Attendee waits for their turn to speak
	while table.current_speaker != null:
		yield(get_tree().create_timer(0.5), "timeout")
	table.current_speaker = self
	
#	Attendee interract at table
	var attendees = table.get_attendees()
	for other_attendee in attendees:
		if self == other_attendee:
			continue
		yield(interact_with_attendee(other_attendee), "completed")
	
	table.current_speaker = null
	phase_completed = true
	
func register_trait(trait):
	if not trait in traits:
		traits.append(trait)
	
func toggle_ivitation(visible:bool):
	$CanvasLayer/Invitation.visible = visible
	
func toggle_visual(visible:bool):
	$Visual.visible = visible

func _on_Invitation_drag():
	get_parent().move_child(self, get_parent().get_child_count() - 1)

func _on_Invitation_select():
	LevelUi.show_attendee_details(self)
	
func un_invite(drop_zone):
	$CanvasLayer/Invitation.un_invited_zone = drop_zone
	$CanvasLayer/Invitation.un_invite()

func get_seat():
	return $CanvasLayer/Invitation.assigned_seat
	
func get_seat_label():
	var seat = get_seat()
	if seat == null:
		return "Not seated"
		
	if seat.single_content:
		return "%s %s" % [
			seat.get_parent().name,
			seat.seat_name
		]
	
	return "%s" % [
			seat.seat_name
		]

func interact_with_attendee(other_attendee):
	yield(get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	for trait in traits:
		for other_trait in other_attendee.traits:

#			print("%s %s interract with %s %s" % [
#				self.full_name, trait.get_identifier(),
#				other_attendee.full_name, other_trait.get_identifier(),
#			])
			yield(trait.interact_with(
					other_attendee, 
					other_trait, 
					Game.Data.current_level.current_phase), "completed")

func interact_with_buffet(seat):
	yield(get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	for trait in traits:
		yield(trait.interact_with_buffet(seat, Game.Data.current_level.current_phase), "completed")
	
func interact_with_bar(seat):
	yield(get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	for trait in traits:
		yield(trait.interact_with_bar(seat, Game.Data.current_level.current_phase), "completed")
	
func interact_with_dancefloor(seat):
	yield(get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	for trait in traits:
		yield(trait.interact_with_dancefloor(seat, Game.Data.current_level.current_phase), "completed")
	
func interact_with_seat_position(seat):
	yield(get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	for trait in traits:
		yield(trait.interact_with_seat(seat, Game.Data.current_level.current_phase), "completed")
	
func interact_with_bride():
	yield(get_tree().create_timer(0.2), "timeout")
	for trait in traits:
		yield(trait.interact_with_bride(Game.Data.current_level.current_phase), "completed")
			
func interact_with_groom():	
	yield(get_tree().create_timer(0.2), "timeout")
	for trait in traits:
		yield(trait.interact_with_groom(Game.Data.current_level.current_phase), "completed")

func play_emote(emote_name):	
	yield($AttendeeVisual.play_emote(emote_name), "completed")
