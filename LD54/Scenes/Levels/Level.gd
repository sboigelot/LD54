extends Node2D

class_name Level

signal new_phase
enum PHASE {PLAN, SEAT, EATDRKINK, PARTY}
var current_phase = PHASE.PLAN

var phase_interaction_events = {
	PHASE.SEAT: [],
	PHASE.EATDRKINK: [],
	PHASE.PARTY: []
} 

export(NodePath) var np_attendee_start_pos2d
onready var attendee_start_pos2D = get_node(np_attendee_start_pos2d) as Position2D

var tables: Array

func register_table(table):
	if not table in tables:
		tables.append(table)

func has_interaction_event(interaction_event)->bool:
	if not phase_interaction_events.has(current_phase):
		return false
		
	for old_event in phase_interaction_events[current_phase]:
		if (interaction_event.attendee1 == old_event.attendee1 and
			interaction_event.trait1 == old_event.trait1 and
			interaction_event.attendee2 == old_event.attendee2 and
			interaction_event.trait2 == old_event.trait2):
			return true
			
		if (interaction_event.attendee1 == old_event.attendee2 and
			interaction_event.trait1 == old_event.trait2 and
			interaction_event.attendee2 == old_event.attendee1 and
			interaction_event.trait2 == old_event.trait1):
			return true
			
	return false

func add_interaction_event(interaction_event):
	if not phase_interaction_events.has(current_phase):
		return

	if not has_interaction_event(interaction_event):
		print(interaction_event.description)
		phase_interaction_events[current_phase].append(interaction_event)

func _ready():
	Game.Data.current_level = self
	LevelUi.show()
	un_invite_all()
	trigger_new_phase_all()
	
func un_invite_all():
	for attendee in $Attendees.get_children():
		attendee.un_invite(LevelUi.guess_book)
		
func trigger_new_phase_all():
#		start yield for all attendee ?
#		for each attendee with x sec delay between each
	var delay_between_attendee = 1.0
	var current_delay = 0.0
	
	for attendee in $Attendees.get_children():
		attendee.on_new_phase(current_delay)
		if attendee.is_invited():
			current_delay += delay_between_attendee
		
func next_phase():
	if current_phase == PHASE.PLAN:
		current_phase = PHASE.SEAT
		trigger_new_phase_all()
#		do not do the collection from the collect_phase_interaction_events() method 
#		collect_phase_interaction_events()

func collect_phase_interaction_events():
	for table in tables:
		table.collect_phase_interaction_events(current_phase)
