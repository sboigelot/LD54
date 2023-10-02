extends MarginContainer

export(NodePath) var np_badge_panel
export(NodePath) var np_angry_background
export(NodePath) var np_happy_background
export(NodePath) var np_spacer_happy
export(NodePath) var np_spacer_angry

export(NodePath) var np_angry_texture_rect
export(NodePath) var np_rich_text_label
export(NodePath) var np_happy_texture_rect

onready var badge_panel = get_node(np_badge_panel) as PanelContainer
onready var angry_background = get_node(np_angry_background) as PanelContainer
onready var happy_background = get_node(np_happy_background) as PanelContainer
onready var spacer_happy = get_node(np_spacer_happy) as MarginContainer
onready var spacer_angry = get_node(np_spacer_angry) as MarginContainer

onready var ui_angry_texture_rect = get_node(np_angry_texture_rect) as TextureRect
onready var ui_rich_text_label = get_node(np_rich_text_label) as RichTextLabel
onready var ui_happy_texture_rect = get_node(np_happy_texture_rect) as TextureRect

func update_ui(interaction_event:InteractionEvent):
	
	angry_background.visible = interaction_event.impact < 0
	happy_background.visible = interaction_event.impact >= 0
	
	spacer_angry.visible = angry_background.visible
	spacer_happy.visible = happy_background.visible
	
	ui_angry_texture_rect.visible = interaction_event.impact < 0
	ui_happy_texture_rect.visible = interaction_event.impact >= 0
	
	ui_rich_text_label.bbcode_text = "%s %s%s[/color]" % [
		interaction_event.description,
		"[color=blue]+" if interaction_event.impact >= 0 else "[color=red]",
		interaction_event.impact
	]
