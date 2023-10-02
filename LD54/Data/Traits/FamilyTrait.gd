extends Trait

class_name FamilyTrait

func get_identifier()->String:
	return "FamilyTrait"
	
func get_display_name()->String:
	return "Family"
	
func get_color()->String:
	return "black" 
	
func get_description()->String:
	return "%s" % [
		"Wants to sit near the table of honor"
	]

func interact_with_seat(seat, phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
	if phase == Level.PHASE.SEAT:
		
		var interaction_event = InteractionEvent.new()
		
		var near_groom_table = seat.near_groom_table
		
		interaction_event.emote1 = "Happy" if near_groom_table else "Angry"
		interaction_event.impact = 1 if near_groom_table else -2
		interaction_event.description = "%s is %s to sit %s the table of honor" % [
			get_parent().full_name,
			"happy" if near_groom_table else "sad",
			"near" if near_groom_table else "far from",
		]
		
		Game.Data.current_level.add_interaction_event(interaction_event)
		yield(get_parent().play_emote(interaction_event.emote1), "completed")
		return
