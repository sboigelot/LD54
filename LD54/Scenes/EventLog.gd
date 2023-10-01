extends PanelContainer

export(PackedScene) var live_event_packed_scene
export(NodePath) var np_live_event_placeholder

onready var ui_live_event_placeholder = get_node(np_live_event_placeholder) as Container

func clear():
	for child in ui_live_event_placeholder.get_children():
		child.queue_free()
		
func add_child_for(interaction_event:InteractionEvent):
	var instance = live_event_packed_scene.instance()
	ui_live_event_placeholder.add_child(instance)
	instance.update_ui(interaction_event)
