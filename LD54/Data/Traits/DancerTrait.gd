extends Trait

class_name DancerTrait

export(bool) var oposite = false

func get_identifier()->String:
	return "DancerTrait"
	
func get_display_name()->String:
	return "Music Hater" if oposite else "Dancer"
	
func get_color()->String:
	return "red" if oposite else "black"
	
func get_description()->String:
	return "%s" % [
		"Wants to sit %s the dancefloor" % ["far from" if oposite else "near"]
	]

func interact_with_seat(seat, phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
	if phase == Level.PHASE.PARTY:
		
		var interaction_event = InteractionEvent.new()
		
		var near_dance_floor = seat.near_dance_floor
		
		var happy = near_dance_floor 
		if oposite:
			happy = not near_dance_floor
		
		interaction_event.emote1 = "Happy" if happy else "Angry"
		interaction_event.impact = 1 if happy else -2
		interaction_event.description = "%s is %s to sit %s the dancefloor" % [
			get_parent().full_name,
			"happy" if happy else "sad",
			"near" if near_dance_floor else "far from",
		]
		
		Game.Data.current_level.add_interaction_event(interaction_event)
		yield(get_parent().play_emote(interaction_event.emote1), "completed")
		return
