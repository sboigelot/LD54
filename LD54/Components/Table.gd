extends Node2D

var current_speaker

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

func everyone_seated()->bool:
	
	for attendee in get_attendees():
		if not attendee.seated:
			return false
	
	return true
