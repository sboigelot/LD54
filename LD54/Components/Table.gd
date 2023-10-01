extends Node2D

func _ready():
	get_parent().register_table(self)

func get_attendees()->Array:
	var invitations = []
	for child in get_children():
		if child.is_in_group("dropzone"):
			if child.single_content:
				if child.content != null:
					invitations.append(child.content)
			else:
				invitations.append_array(child.items)
	
	var attendees = []
	for invitation in invitations:
		attendees.append(invitation.get_parent())
	return attendees

func collect_phase_interaction_events(current_phase):
	var attendees = get_attendees()
	for attendee in attendees:
		for other_attendee in attendees:
			if attendee == other_attendee:
				continue
			attendee.interact_with_attendee(other_attendee)