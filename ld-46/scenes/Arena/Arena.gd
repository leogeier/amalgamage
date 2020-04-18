extends Node2D


const block = preload("res://scenes/Block/Block.tscn")

#func _ready():
#	pass

#func _process(delta):
#	pass

func spawn_block(pos):
	var new_block = block.instance()
	new_block.position = pos
	add_child(new_block)
