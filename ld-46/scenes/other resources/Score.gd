extends Node


var score: int = 0 setget set_score, get_score
var game_over = false


func set_score(new_val):
	score = new_val

func get_score():
	return score

func reset_score():
	score = 1

func _process(delta):
	# Should probably not be in here
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
