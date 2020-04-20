extends Node2D


export(float) var block_velocity = 10
export(float) var shake_strength = 1
export(int) var max_spawn_controllers = 3

var screenshake_start
var screenshake_duration = 0

var spawn_controller_count = 0

const block = preload("res://scenes/Block/Block.tscn")


func shake(duration = 100):
	screenshake_start = OS.get_ticks_msec()
	screenshake_duration = duration

func spawn_block(pos, dir, rot, force):
	var new_block = block.instance()
	add_child(new_block)
	new_block.position = pos
	new_block.rotation = rot
	new_block.direction = dir
	new_block.velocity = block_velocity
	new_block.force = force

func add_spawn_controller():
	var new_controller = $ProtoSpawnController.duplicate()
	new_controller.active = true
	add_child(new_controller)
	
	spawn_controller_count += 1
	if spawn_controller_count >= max_spawn_controllers:
		$SpawnControllerTimer.stop()

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
	
	add_spawn_controller()
	$SpawnControllerTimer.connect("timeout", self, "add_spawn_controller")
