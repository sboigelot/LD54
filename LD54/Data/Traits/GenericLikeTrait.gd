extends Trait

class_name GenericLikeTrait

export(String) var topic
export(bool) var dislike

func get_identifier()->String:
	return "GenericLikeTrait"

func get_display_name()->String:
	return topic
	
func get_color()->Color:
	return Color.lime if dislike else Color.red
	
func get_description()->String:
	return "%s %s" % [
		"Dislikes" if dislike else "Likes",
		topic
	]
	
func interact_with(other_attendee, other_trait, phase)->InteractionEvent:
	if other_trait.get_identifier() != "GenericLikeTrait":
		return null
		
	if other_trait.topic != topic:
		return null
		
	var interaction_event = InteractionEvent.new()
	interaction_event.attendee1 = get_parent()
	interaction_event.trait1 = self
	interaction_event.attendee2 = other_attendee
	interaction_event.trait2 = other_trait
	
	var agree = other_trait.dislike == dislike
	
	interaction_event.emote1 = "bounded" if agree else "argued"
	interaction_event.emote2 = "bounded" if agree else "argued"
	interaction_event.impact = 1
	interaction_event.description = "%s and %s %s over %s%s" % [
		get_parent().full_name,
		other_attendee.full_name,
		"bounded" if agree else "argued",
		("their love of " if not dislike else "their hate of ") if agree else "",
		topic
	]
	
		
	return interaction_event
	
