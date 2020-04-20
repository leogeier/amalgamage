extends Node2D


var spawn_start
var warn_duration = 0
var kind
var dir
var arena
var remove = false
var block_force

const blink_period = 800


func start_spawn(new_kind, new_dir, new_warn_dur = 4000, angle_var = .4):
	dir = new_dir.rotated(rand_range(-angle_var, angle_var))
	$Arrow.look_at(global_position + dir * 5)
	spawn_start = OS.get_ticks_msec()
	warn_duration = new_warn_dur
	kind = new_kind

func spawn_block():
	arena.spawn_block(global_position	, dir, 0, block_force)

func schedule_removal():
	remove = true

func _ready():
	var arena_group = get_tree().get_nodes_in_group("arena")
	if not arena_group.empty():
		arena = arena_group[0]
	
	$SpawnSound.connect("finished", self, "schedule_removal")

func _process(delta):
	if spawn_start != null and arena != null:
		var elapsedTime = OS.get_ticks_msec() - spawn_start
		if elapsedTime > warn_duration:
			if kind == "block":
				spawn_block()
			$SpawnSound.play()
			hide()
			spawn_start = null
		else:
			if elapsedTime % blink_period < blink_period / 2:
				if !is_visible():
					$WarnSound.play()
				show()
			else:
				hide()
	
	if remove:
		get_parent().remove_child(self)
		queue_free()
