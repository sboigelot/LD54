extends Node2D

export(String) var full_name
export(PoolStringArray) var tags

export(PoolStringArray) var loves
export(PoolStringArray) var likes
export(PoolStringArray) var dislikes
export(PoolStringArray) var hates

export(int) var mood = 0

const MOOD_IMPACT_LOVE = 3
const MOOD_IMPACT_LIKE = 1
const MOOD_IMPACT_DISLIKE = -2
const MOOD_IMPACT_HATES = -5

export(Texture) var face_texture
export(Texture) var body_texture
export(Texture) var hair_texture

export(Texture) var happy_eyebrow_texture
export(Texture) var happy_eyes_texture
export(Texture) var happy_mouth_texture

export(Texture) var normal_eyebrow_texture
export(Texture) var normal_eyes_texture
export(Texture) var normal_mouth_texture

export(Texture) var angry_eyebrow_texture
export(Texture) var angry_eyes_texture
export(Texture) var angry_mouth_texture

export(NodePath) var np_face_sprite
export(NodePath) var np_body_sprite
export(NodePath) var np_hair_sprite

export(NodePath) var np_happy_eyebrow_sprite
export(NodePath) var np_normal_eyebrow_sprite
export(NodePath) var np_angry_eyebrow_sprite

export(NodePath) var np_happy_eyes_sprite
export(NodePath) var np_normal_eyes_sprite
export(NodePath) var np_angry_eyes_sprite

export(NodePath) var np_happy_mouth_sprite
export(NodePath) var np_normal_mouth_sprite
export(NodePath) var np_angry_mouth_sprite

export(NodePath) var np_invitation_name_label

onready var face_sprite = get_node(np_face_sprite) as Sprite
onready var body_sprite = get_node(np_body_sprite) as Sprite
onready var hair_sprite = get_node(np_hair_sprite) as Sprite

onready var happy_eyebrow_sprite = get_node(np_happy_eyebrow_sprite) as Sprite
onready var normal_eyebrow_sprite = get_node(np_normal_eyebrow_sprite) as Sprite
onready var angry_eyebrow_sprite = get_node(np_angry_eyebrow_sprite) as Sprite

onready var happy_eyes_sprite = get_node(np_happy_eyes_sprite) as Sprite
onready var normal_eyes_sprite = get_node(np_normal_eyes_sprite) as Sprite
onready var angry_eyes_sprite = get_node(np_angry_eyes_sprite) as Sprite

onready var happy_mouth_sprite = get_node(np_happy_mouth_sprite) as Sprite
onready var normal_mouth_sprite = get_node(np_normal_mouth_sprite) as Sprite
onready var angry_mouth_sprite = get_node(np_angry_mouth_sprite) as Sprite

onready var invitation_name_label = get_node(np_invitation_name_label) as Label

var assigned_seat

func _ready():
	update_sprites()

func update_sprites():
	
	apply_texture_to_sprite(face_texture, face_sprite)
	apply_texture_to_sprite(body_texture, body_sprite)
	apply_texture_to_sprite(hair_texture, hair_sprite)
	
	apply_texture_to_sprite(happy_eyebrow_texture, happy_eyebrow_sprite)
	apply_texture_to_sprite(normal_eyebrow_texture, normal_eyebrow_sprite)
	apply_texture_to_sprite(angry_eyebrow_texture, angry_eyebrow_sprite)
	
	apply_texture_to_sprite(happy_eyes_texture, happy_eyes_sprite)
	apply_texture_to_sprite(normal_eyes_texture, normal_eyes_sprite)
	apply_texture_to_sprite(angry_eyes_texture, angry_eyes_sprite)
	
	apply_texture_to_sprite(happy_mouth_texture, happy_mouth_sprite)
	apply_texture_to_sprite(normal_mouth_texture, normal_mouth_sprite)
	apply_texture_to_sprite(angry_mouth_texture, angry_mouth_sprite)
	
	invitation_name_label.text = full_name
	
func apply_texture_to_sprite(texture:Texture, sprite:Sprite):
	sprite.visible = texture != null
	sprite.texture = texture
	
func toggle_ivitation(visible:bool):
	$Invitation.visible = visible
	
func toggle_visual(visible:bool):
	$Visual.visible = visible

func _on_Invitation_drag():
	get_parent().move_child(self, get_parent().get_child_count() - 1)
