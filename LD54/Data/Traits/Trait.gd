extends Node

class_name Trait

func _ready():
	get_parent().register_trait(self)

func get_identifier()->String:
	return "Trait"
	
func get_display_name()->String:
	return "Trait"
	
func get_color()->Color:
	return Color.green
	
func get_description()->String:
	return "Description"
	
func interact_with(other_attendee, other_trait, phase)->InteractionEvent:
	return null
	
func interact_with_seat(seqt, phase)->InteractionEvent:
	return null
	
func interact_with_bride(phase)->InteractionEvent:
	return null
	
func interact_with_groom(phase)->InteractionEvent:
	return null
