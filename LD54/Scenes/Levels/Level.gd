extends Node2D

func _ready():
	LevelUi.show()
	un_invite_all()
	
func un_invite_all():
	for attendee in $Attendees.get_children():
		attendee.un_invite(LevelUi.guess_book)
