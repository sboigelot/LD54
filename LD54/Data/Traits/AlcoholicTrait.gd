extends Trait

class_name AlcoholicTrait

func get_identifier()->String:
	return "AlcoholicTrait"
	
func get_display_name()->String:
	return "Alcoholic"
	
func get_color()->String:
	return "red" 
	
func get_description()->String:
	return "%s" % [
		"Loves alcohol"
	]

func interact_with_bar(seat, phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
	if phase == Level.PHASE.EATDRKINK:
		
		var interaction_event = InteractionEvent.new()
		
		var near_bar = seat.near_bar
		
		interaction_event.emote1 = "Happy" if near_bar else "Angry"
		interaction_event.impact = 1 if near_bar else -1
		interaction_event.description = "%s is %s to sit %s the bar" % [
			get_parent().full_name,
			"happy" if near_bar else "sad",
			"near" if near_bar else "far from",
		]
		
		Game.Data.current_level.add_interaction_event(interaction_event)
		yield(get_parent().play_emote(interaction_event.emote1), "completed")
		return
		
	if phase == Level.PHASE.PARTY and seat.near_bar:
		
		var interaction_event = InteractionEvent.new()
		
		interaction_event.emote1 = "Angry"
		interaction_event.impact = -5
		interaction_event.description = "%s got drunk and bothered everyone" % [
			get_parent().full_name
		]
		
		Game.Data.current_level.add_interaction_event(interaction_event)
		yield(get_parent().play_emote(interaction_event.emote1), "completed")
		return
	
