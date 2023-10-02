extends Node

class_name Trait

export(bool) var hidden_trait = false

func _ready():
	get_parent().register_trait(self)

func get_hidden()->bool:
	return hidden_trait
	
func get_identifier()->String:
	return "Trait"
	
func get_display_name()->String:
	return "Trait"
	
func get_color()->String:
	return "green"
	
func get_description()->String:
	return "Description"
	
func interact_with(other_attendee, other_trait, phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")

func interact_with_buffet(seat, phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
func interact_with_bar(seat, phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
func interact_with_dancefloor(seat, phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
func interact_with_seat(seat, phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
func interact_with_bride(phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")

func interact_with_groom(phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")

func interaction_already_happend(other_attendee, other_trait)->bool:
	return Game.Data.current_level.has_interaction(
		get_parent().full_name, 
		self.get_identifier(), 
		other_attendee.full_name, 
		other_trait.get_identifier())
