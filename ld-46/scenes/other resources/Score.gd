extends Node


var score: int = 0 setget set_score, get_score


func set_score(new_val):
	score = new_val

func get_score():
	return score

func reset_score():
	score = 0