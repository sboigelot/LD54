extends MarginContainer

export(NodePath) var np_angry_texture_rect
export(NodePath) var np_rich_text_label
export(NodePath) var np_happy_texture_rect

onready var ui_angry_texture_rect = get_node(np_angry_texture_rect) as TextureRect
onready var ui_rich_text_label = get_node(np_rich_text_label) as RichTextLabel
onready var ui_happy_texture_rect = get_node(np_happy_texture_rect) as TextureRect

func update_ui(interaction_event:InteractionEvent):
	ui_angry_texture_rect.visible = interaction_event.impact < 0
	ui_happy_texture_rect.visible = interaction_event.impact >= 0
	
	ui_rich_text_label.bbcode_text = "%s %s%s[/color]" % [
		interaction_event.description,
		"[color=lime]+" if interaction_event.impact >= 0 else "[color=red]",
		interaction_event.impact
	]
	
