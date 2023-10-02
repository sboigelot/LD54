extends Node2D

export(NodePath) var np_hair_sprite
export(NodePath) var np_eyes_sprite
export(NodePath) var np_face_sprite
export(NodePath) var np_body_sprite
export(NodePath) var np_speech_bubble_animation_player

onready var hair_sprite = get_node(np_hair_sprite) as Sprite
onready var eyes_sprite = get_node(np_eyes_sprite) as Sprite
onready var face_sprite = get_node(np_face_sprite) as Sprite
onready var body_sprite = get_node(np_body_sprite) as Sprite
onready var speech_bubble_animation_player = get_node(np_speech_bubble_animation_player) as AnimationPlayer

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
	z_index = global_position.y

func move_towards_destination(delta):
	if not moving:
		return
	
	global_position = global_position.move_toward(destination, speed * delta)
		
	if global_position.distance_to(destination) <= move_threshold:
		moving = false
		emit_signal("move_completed")

func play_emote(emote_name):
	yield(Game.get_tree(), "idle_frame")
	if speech_bubble_animation_player.is_playing():
		yield(speech_bubble_animation_player, "animation_finished")
		
	speech_bubble_animation_player.play(emote_name)
	yield(speech_bubble_animation_player, "animation_finished")
	
func play_loop_emote(emote_name):
	if speech_bubble_animation_player.is_playing():
		yield(speech_bubble_animation_player, "animation_finished")
		
	speech_bubble_animation_player.play(emote_name)

func stop_loop_emote():
	if speech_bubble_animation_player.is_playing():
		speech_bubble_animation_player.stop()

func _on_Area2D_mouse_entered():
	LevelUi.show_attendee_details(get_parent())

func _on_Area2D_mouse_exited():
	LevelUi.hide_attendee_details()
