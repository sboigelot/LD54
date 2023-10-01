extends Node2D

class_name Attendee

signal phase_completed

export(String) var full_name
export(PoolStringArray) var tags

export(int) var mood = 0

const MOOD_IMPACT_LOVE = 3
const MOOD_IMPACT_LIKE = 1
const MOOD_IMPACT_DISLIKE = -2
const MOOD_IMPACT_HATES = -5

export(Texture) var hair_texture
export(Texture) var eyes_texture
export(Texture) var face_texture
export(Texture) var body_texture

var traits: Array

var seated: bool = false

func _ready():
	$AttendeeVisual.update_sprites(self)
	$Invitation.update_attendee(self)

func on_new_phase(delay):
	match Game.Data.current_level.current_phase:
		Level.PHASE.PLAN:
			$AttendeeVisual.visible = false
			$Invitation.visible = true
			
		Level.PHASE.SEAT:
			start_phase_seat(delay)
			
		Level.PHASE.EATDRKINK:
			$AttendeeVisual.visible = true
			$Invitation.visible = false
			
		Level.PHASE.PARTY:
			$AttendeeVisual.visible = true
			$Invitation.visible = false

func is_invited()->bool:
	return get_seat() != null and get_seat().single_content

func start_phase_seat(delay):
	
	var invited = is_invited()
	
	seated = false
	$AttendeeVisual.visible = invited
	$AttendeeVisual.global_position = Game.Data.current_level.attendee_start_pos2D.global_position
	$Invitation.visible = false
	
	if not invited:
		return
			
	if delay > 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	
#	Attendee go to bride/groom
	var bride_position = Vector2(100, 100)
	$AttendeeVisual.start_move_to(bride_position)
	yield($AttendeeVisual, "move_completed")
	
#	Attendee interract with groom
	yield(interact_with_bride(), "completed")

#	Attendee go to groom
	var groom_position = Vector2(50, 100)
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
	
#	Attendee interract at table
	var attendees = table.get_attendees()
	for other_attendee in attendees:
		if self == other_attendee:
			continue
		yield(interact_with_attendee(other_attendee), "completed")
		
	emit_signal("phase_completed")
	
func register_trait(trait):
	if not trait in traits:
		traits.append(trait)
	
func toggle_ivitation(visible:bool):
	$Invitation.visible = visible
	
func toggle_visual(visible:bool):
	$Visual.visible = visible

func _on_Invitation_drag():
	get_parent().move_child(self, get_parent().get_child_count() - 1)

func _on_Invitation_select():
	LevelUi.show_attendee_details(self)
	
func un_invite(drop_zone):
	$Invitation.un_invited_zone = drop_zone
	$Invitation.un_invite()

func get_seat():
	return $Invitation.assigned_seat
	
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
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	for trait in traits:
		for other_trait in other_attendee.traits:
			var interaction_event = trait.interact_with(
				other_attendee, 
				other_trait, 
				Game.Data.current_level.current_phase)
			if interaction_event != null:
				Game.Data.current_level.add_interaction_event(interaction_event)

	
func interact_with_seat_position(seat):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	for trait in traits:
		var interaction_event = trait.interact_with_seat(
										seat,
										Game.Data.current_level.current_phase)
		if interaction_event != null:
			Game.Data.current_level.add_interaction_event(interaction_event)
	
func interact_with_bride():
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	for trait in traits:
		var interaction_event = trait.interact_with_bride(
					Game.Data.current_level.current_phase)
		if interaction_event != null:
			Game.Data.current_level.add_interaction_event(interaction_event)
			
func interact_with_groom():	
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	for trait in traits:
		var interaction_event = trait.interact_with_groom(
					Game.Data.current_level.current_phase)
		if interaction_event != null:
			Game.Data.current_level.add_interaction_event(interaction_event)
