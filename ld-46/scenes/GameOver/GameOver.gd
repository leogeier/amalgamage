extends Node2D


func _ready():
	$Score.text = "The Amalgam is dead.\nIt grew to a size of\n" + str(Score.score)

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		get_tree().change_scene("res://scenes/Arena/Arena.tscn")
