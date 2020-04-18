extends Node2D


export(float) var block_velocity = 10

const block = preload("res://scenes/Block/Block.tscn")


#func _ready():
#	pass

#func _process(delta):
#	pass

func spawn_block(pos, dir, rot):
	var new_block = block.instance()
	new_block.position = pos
	new_block.rotation = rot
	new_block.direction = dir
	new_block.velocity = block_velocity
	add_child(new_block)
