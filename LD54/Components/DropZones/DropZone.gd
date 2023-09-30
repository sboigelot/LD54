extends Node2D

export var single_content:bool = true

var content
var items: Array

func _ready():
	add_to_group("dropzone")

func capture(position)->bool:
	return (position.x >= $DropPanel.rect_global_position.x and
			position.y >= $DropPanel.rect_global_position.y and
			position.x <= $DropPanel.rect_global_position.x + $DropPanel.rect_size.x and
			position.y <= $DropPanel.rect_global_position.y + $DropPanel.rect_size.y)
			
func has_free_space(requester)->bool:
	return not single_content or content == null
	
func can_swap(requester)->bool:
	return content != null
	
