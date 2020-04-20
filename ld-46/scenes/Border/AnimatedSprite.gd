extends AnimatedSprite


var rot_speed
var initial_wait
var start_time


func _ready():
	frame = randi() % 4
	rot_speed = rand_range(-1, 1)
	initial_wait = randi() % 1000
	start_time = OS.get_ticks_msec()

func _process(delta):
	if start_time + initial_wait < OS.get_ticks_msec():
		playing = true
	
	rotate(rot_speed * delta)
