extends Node2D

class_name Attendee

export(String) var full_name
export(PoolStringArray) var tags

export(PoolStringArray) var loves
export(PoolStringArray) var likes
export(PoolStringArray) var dislikes
export(PoolStringArray) var hates

export(int) var mood = 0

const MOOD_IMPACT_LOVE = 3
const MOOD_IMPACT_LIKE = 1
const MOOD_IMPACT_DISLIKE = -2
const MOOD_IMPACT_HATES = -5

export(Texture) var hair_texture
export(Texture) var eyes_texture
export(Texture) var face_texture
export(Texture) var body_texture

func _ready():
	$AttendeeVisual.update_sprites(self)
	$Invitation.update_attendee(self)
	
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
			seat.name
		]
	
	return "%s" % [
			seat.name
		]
