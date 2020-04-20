extends Node2D


export(float) var radius = 75
# in radians
export(float) var velocity = 2
export var shoot_delay = 1000

# in radians
var cur_rot = 0
var last_shoot_time = -INF
onready var sprite = $Sprite
var arena

const TWO_PI = 2 * PI


func _ready():
	sprite.position = Vector2(radius, 0)
	
	var arena_group = get_tree().get_nodes_in_group("arena")
	if not arena_group.empty():
		arena = arena_group[0]

func _process(delta):
	# Input
	if Input.is_action_pressed("ui_left"):
		cur_rot -= velocity * delta
	elif Input.is_action_pressed("ui_right"):
		cur_rot += velocity * delta
	
	var cur_time = OS.get_ticks_msec()
	var spawn_block = false
	if Input.is_action_just_pressed("shoot") \
		and cur_time >= last_shoot_time + shoot_delay \
		and arena != null:
		
		last_shoot_time = cur_time
		spawn_block = true
	
	# Logic
	if cur_rot < 0:
		cur_rot += TWO_PI
	elif cur_rot > TWO_PI:
		cur_rot -= TWO_PI
	
	var shooter_pos = \
		Vector2(sin(cur_rot) * radius, cos(cur_rot) * radius)
	
	sprite.look_at(get_global_mouse_position())
	sprite.position = shooter_pos
	
	if spawn_block:
		var pos = position + shooter_pos
		var shooter_rot = sprite.rotation
		var dir = Vector2(1,0).rotated(shooter_rot)
		arena.spawn_block(pos, dir, -cur_rot)
		$ShootSound.play()
