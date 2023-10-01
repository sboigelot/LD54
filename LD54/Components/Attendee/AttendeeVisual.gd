extends Node2D

export(NodePath) var np_hair_sprite
export(NodePath) var np_eyes_sprite
export(NodePath) var np_face_sprite
export(NodePath) var np_body_sprite

onready var hair_sprite = get_node(np_hair_sprite) as Sprite
onready var eyes_sprite = get_node(np_eyes_sprite) as Sprite
onready var face_sprite = get_node(np_face_sprite) as Sprite
onready var body_sprite = get_node(np_body_sprite) as Sprite

signal move_completed
var move_threshold:float = 5.0
var destination:Vector2
var moving:bool
var speed:float = 300.0

func update_sprites(attendee):
	apply_texture_to_sprite(attendee.hair_texture, hair_sprite)
	apply_texture_to_sprite(attendee.eyes_texture, eyes_sprite)
	apply_texture_to_sprite(attendee.face_texture, face_sprite)
	apply_texture_to_sprite(attendee.body_texture, body_sprite)
	
func apply_texture_to_sprite(texture:Texture, sprite:Sprite):
	sprite.visible = texture != null
	sprite.texture = texture
	
func start_move_to(target):
	destination = target
	moving = true
	
func _physics_process(delta):
	move_towards_destination(delta)

func move_towards_destination(delta):
	if not moving:
		return
	
	global_position = global_position.move_toward(destination, speed * delta)
		
	if global_position.distance_to(destination) <= move_threshold:
		moving = false
		emit_signal("move_completed")
