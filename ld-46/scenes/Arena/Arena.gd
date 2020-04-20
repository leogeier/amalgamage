extends Node2D


export(float) var block_velocity = 10
export(float) var shake_strength = 1

var screenshake_start
var screenshake_duration = 0

const block = preload("res://scenes/Block/Block.tscn")


func shake(duration = 100):
	screenshake_start = OS.get_ticks_msec()
	screenshake_duration = duration

func spawn_block(pos, dir, rot):
	var new_block = block.instance()
	new_block.position = pos
	new_block.rotation = rot
	new_block.direction = dir
	new_block.velocity = block_velocity
	add_child(new_block)

func _process(delta):
	if screenshake_start != null:
		if screenshake_start + screenshake_duration < OS.get_ticks_msec():
			screenshake_start = null
			position = Vector2(0,0)
			return
		
		position = Vector2(rand_range(-1,1),rand_range(-1,1)) * shake_strength

func _ready():
	Score.reset_score()
	randomize()
