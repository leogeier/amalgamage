extends Node2D


export(float) var spawn_delay = 10.0
export(float) var min_delay = 4.5
export(float) var delay_variation = 0.8
export(float) var delay_reduction = 0.5
export(bool) var active = true setget set_active
export(float) var radius = 90.0
export(String) var kind = "block"
export(float) var block_force = 10

var amalgam

const enemy_spawner = preload("res://scenes/EnemySpawner/EnemySpawner.tscn")


func set_active(new_val):
	active = new_val
	$SpawnTimer.paused = !new_val

func handle_spawn_timer():
	new_spawn()
	spawn_delay = max(spawn_delay - delay_reduction, min_delay)
	prepare_timer()

func new_spawn():
	var spawner_pos = Vector2(radius,0).rotated(randf() * 2 * PI)
	
	var new_spawner = enemy_spawner.instance()
	add_child(new_spawner)
	new_spawner.position = spawner_pos
	new_spawner.block_force = block_force
	
	var dir = (amalgam.global_position - to_global(spawner_pos)).normalized()
	new_spawner.start_spawn(kind, dir)

func prepare_timer():
	var delay = spawn_delay + rand_range(-delay_variation, delay_variation)
	$SpawnTimer.start(delay)

func _ready():
	var amalgam_group = get_tree().get_nodes_in_group("amalgam")
	if amalgam_group.empty():
		return
	
	amalgam = amalgam_group[0]
	
	$SpawnTimer.connect("timeout", self, "handle_spawn_timer")
	
	$SpawnTimer.start(randf() * 2.0 + 4.0)
