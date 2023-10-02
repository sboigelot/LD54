extends Trait

class_name SingleTrait

export(bool) var build_an_harem
var found_love:bool = false

func get_identifier()->String:
	return "SingleTrait"

func get_display_name()->String:
	return "Single"
	
func get_color()->String:
	return "black"
	
func get_description()->String:
	return "Search for love" % []

func interact_with(other_attendee, other_trait, phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
	if phase != Level.PHASE.PARTY:
		return
	
	if other_trait.get_identifier() != get_identifier():
		return
		
	if found_love or other_trait.found_love:
		return
	
	if interaction_already_happend(other_attendee, other_trait):
		return
		
	found_love = not build_an_harem
	other_trait.found_love = not other_trait.build_an_harem
		
	var interaction_event = InteractionEvent.new()
	interaction_event.attendee1 = get_parent().full_name
	interaction_event.trait1 = self.get_identifier()
	interaction_event.attendee2 = other_attendee.full_name
	interaction_event.trait2 = other_trait.get_identifier()
	
	interaction_event.emote1 = "Happy"
	interaction_event.emote2 = "Happy"
	interaction_event.impact = 2 if build_an_harem else 3
	
	if build_an_harem:
		interaction_event.description = "%s welcomed %s in their harem" % [
			get_parent().full_name,
			other_attendee.full_name,
		]
	elif other_trait.build_an_harem:
		interaction_event.description = "%s welcomed %s in their harem" % [
			other_attendee.full_name,
			get_parent().full_name,
		]
	else:
		interaction_event.description = "%s and %s fell in love" % [
			get_parent().full_name,
			other_attendee.full_name,
		]
	
	Game.Data.current_level.add_interaction_event(interaction_event)
	get_parent().play_emote(interaction_event.emote1)
	yield(other_attendee.play_emote(interaction_event.emote2), "completed")
	
