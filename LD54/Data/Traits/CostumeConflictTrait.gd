extends Trait

class_name CostumeConflictTrait

export(bool) var of_bride
export(bool) var of_groom

export(String) var costume_part = "dress"

func get_identifier()->String:
	return "CostumeConflict"

func get_display_name()->String:
	return "CostumeConflict"
	
func get_color()->String:
	return "red"
	
func get_description()->String:
	return "Costume conflict with the %s" % [
			get_parent().full_name,
			"bride" if of_bride else "groom"
		]

func interact_with_bride(phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
	if not of_bride:
		return
		
	var interaction_event = InteractionEvent.new()
	interaction_event.attendee1 = get_parent().full_name
	interaction_event.trait1 = self.get_identifier()
	interaction_event.attendee2 = Game.Data.current_level.bride.full_name
	interaction_event.trait2 = self.get_identifier()
	
	interaction_event.emote1 = "Angry"
	interaction_event.emote2 = "Angry"
	interaction_event.impact = -3
	interaction_event.description = "%s wears the same %s as the bride!" % [get_parent().full_name, costume_part]
	
	Game.Data.current_level.add_interaction_event(interaction_event)
	yield(Game.Data.current_level.bride.play_emote(interaction_event.emote2), "completed")
	
func interact_with_groom(phase):
	yield(Game.get_tree(), "idle_frame") # prevent issue with yield(this_func(), "completed")
	
	if not of_groom:
		return
		
	var interaction_event = InteractionEvent.new()
	interaction_event.attendee1 = get_parent().full_name
	interaction_event.trait1 = self.get_identifier()
	interaction_event.attendee2 = Game.Data.current_level.groom.full_name
	interaction_event.trait2 = self.get_identifier()
	
	interaction_event.emote1 = "Angry"
	interaction_event.emote2 = "Angry"
	interaction_event.impact = -3
	interaction_event.description = "%s wears the same %s as the groom!"  % [get_parent().full_name, costume_part]
	
	Game.Data.current_level.add_interaction_event(interaction_event)
	yield(Game.Data.current_level.groom.play_emote(interaction_event.emote2), "completed")
	
