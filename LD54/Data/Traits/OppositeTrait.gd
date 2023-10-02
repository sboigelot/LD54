extends Trait

class_name OppositeTrait

export(Level.PHASE) var trigger_phase = Level.PHASE.EATDRKINK
export(String) var display_name = "Vegan"
export(String) var argue_over = "the morality of eating animals"
export(String, MULTILINE) var description = "Doesn't eat animal products, and will let you know!"
export(String) var color = "black"
export(String) var opposite_identifier = "Meat Lover"
export(String, MULTILINE) var opposite_description = "Loves steak wrapped in bacon."
export(bool) var is_opposite = false
export(int) var happy_impact = 1
export(int) var happy_opposite_impact = 1
export(int) var angry_impact = -2

func get_identifier()->String:
	return get_display_name()

func get_display_name()->String:
	return display_name if not is_opposite else opposite_identifier
	
func get_color()->String:
	return color
	
func get_description()->String:
	return description if not is_opposite else opposite_description

func interact_with(other_attendee, other_trait, phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
	if phase != trigger_phase:
		return
	
	if (other_trait.get_identifier() != get_identifier() and
		other_trait.get_identifier() != opposite_identifier):
		return
	
	var agree = other_trait.get_identifier() == get_identifier()
	
	if agree and happy_impact == 0 and not is_opposite:
		return
		
	if agree and happy_opposite_impact == 0 and is_opposite:
		return
		
	if interaction_already_happend(other_attendee, other_trait):
		return	
		
	var interaction_event = InteractionEvent.new()
	interaction_event.attendee1 = get_parent().full_name
	interaction_event.trait1 = self.get_identifier()
	interaction_event.attendee2 = other_attendee.full_name
	interaction_event.trait2 = other_trait.get_identifier()
	
	interaction_event.emote1 = "Happy" if agree else "Angry"
	interaction_event.emote2 = "Happy" if agree else "Angry"
	interaction_event.impact = (happy_opposite_impact if is_opposite else happy_impact) if agree else angry_impact
	
	interaction_event.description = "%s and %s %s %s" % [
		get_parent().full_name,
		other_attendee.full_name,
		"share beliefs about" if agree else "fought over",
		argue_over
	]
	
	Game.Data.current_level.add_interaction_event(interaction_event)
	get_parent().play_emote(interaction_event.emote1)
	yield(other_attendee.play_emote(interaction_event.emote2), "completed")
	
