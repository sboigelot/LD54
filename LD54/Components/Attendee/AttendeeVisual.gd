extends Node2D

export(NodePath) var np_hair_sprite
export(NodePath) var np_eyes_sprite
export(NodePath) var np_face_sprite
export(NodePath) var np_body_sprite

onready var hair_sprite = get_node(np_hair_sprite) as Sprite
onready var eyes_sprite = get_node(np_eyes_sprite) as Sprite
onready var face_sprite = get_node(np_face_sprite) as Sprite
onready var body_sprite = get_node(np_body_sprite) as Sprite

func update_sprites(attendee:Attendee):
	apply_texture_to_sprite(attendee.hair_texture, hair_sprite)
	apply_texture_to_sprite(attendee.eyes_texture, eyes_sprite)
	apply_texture_to_sprite(attendee.face_texture, face_sprite)
	apply_texture_to_sprite(attendee.body_texture, body_sprite)
	
func apply_texture_to_sprite(texture:Texture, sprite:Sprite):
	sprite.visible = texture != null
	sprite.texture = texture
	
