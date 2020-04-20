extends Node2D


export(float) var shake_strength = 1

var screenshake_start
var screenshake_duration = 0


func shake(duration = 100):
	screenshake_start = OS.get_ticks_msec()
	screenshake_duration = duration

func _ready():
	$Score.text = str(Score.score)
	TransitionSounds.play_hit()
	shake()
	
	$ScoreTimer.connect("timeout", self, "show_score")
	$ContinueTimer.connect("timeout", self, "show_continue")

func show_score():
	$Score.show()
	shake()
	TransitionSounds.play_hit()

func show_continue():
	$Continue.show()
	shake()
	TransitionSounds.play_hit()

func _process(delta):
	if Input.is_action_just_pressed("shoot") and $ContinueTimer.is_stopped():
		TransitionSounds.play_hit()
		get_tree().change_scene("res://scenes/Title/Title.tscn")
	
	if screenshake_start != null:
		if screenshake_start + screenshake_duration < OS.get_ticks_msec():
			screenshake_start = null
			position = Vector2(0,0)
			return
		
		position = Vector2(rand_range(-1,1),rand_range(-1,1)) * shake_strength
