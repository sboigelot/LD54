extends Node2D

class_name Attendee

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

export(Texture) var hair_texture
export(Texture) var eyes_texture
export(Texture) var face_texture
export(Texture) var body_texture

export(NodePath) var np_hair_sprite
export(NodePath) var np_eyes_sprite
export(NodePath) var np_face_sprite
export(NodePath) var np_body_sprite

onready var hair_sprite = get_node(np_hair_sprite) as Sprite
onready var eyes_sprite = get_node(np_eyes_sprite) as Sprite
onready var face_sprite = get_node(np_face_sprite) as Sprite
onready var body_sprite = get_node(np_body_sprite) as Sprite

export(NodePath) var np_invitation_name_label
onready var invitation_name_label = get_node(np_invitation_name_label) as Label

var assigned_seat

func _ready():
	update_sprites()

func update_sprites():
	
	apply_texture_to_sprite(hair_texture, hair_sprite)
	apply_texture_to_sprite(eyes_texture, eyes_sprite)
	apply_texture_to_sprite(face_texture, face_sprite)
	apply_texture_to_sprite(body_texture, body_sprite)
	
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

func _on_Invitation_select():
	LevelUi.show_attendee_details(self)
	
func un_invite(drop_zone):
	$Invitation.move_to_drop_zone(drop_zone)
