extends Trait

class_name GenericLikeTrait

export(String) var topic
export(bool) var dislike

func get_identifier()->String:
	return "GenericLikeTrait.%s" % get_display_name()

func get_display_name()->String:
	return topic
	
func get_color()->String:
	return "red" if dislike else "green"
	
func get_description()->String:
	return "%s %s" % [
		"Dislikes" if dislike else "Likes",
		topic
	]

func interact_with(other_attendee, other_trait, phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
	if other_trait.get_identifier() != get_identifier():
		return
		
	if other_trait.topic != topic:
		return
	
	if interaction_already_happend(other_attendee, other_trait):
		return
		
	var interaction_event = InteractionEvent.new()
	interaction_event.attendee1 = get_parent().full_name
	interaction_event.trait1 = self.get_identifier()
	interaction_event.attendee2 = other_attendee.full_name
	interaction_event.trait2 = other_trait.get_identifier()
	
	var agree = other_trait.dislike == dislike
	
	interaction_event.emote1 = "Happy" if agree else "Angry"
	interaction_event.emote2 = "Happy" if agree else "Angry"
	interaction_event.impact = 1 if agree else -1
	interaction_event.description = "%s and %s %s over %s%s" % [
		get_parent().full_name,
		other_attendee.full_name,
		"bounded" if agree else "argued",
		("their love of " if not dislike else "their hate of ") if agree else "",
		topic
	]
	
	Game.Data.current_level.add_interaction_event(interaction_event)
	get_parent().play_emote(interaction_event.emote1)
	yield(other_attendee.play_emote(interaction_event.emote2), "completed")
	
