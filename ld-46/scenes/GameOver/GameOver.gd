extends Node2D


func _ready():
	$Score.text = str(Score.score)
	$ReadySound

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		get_tree().change_scene("res://scenes/Arena/Arena.tscn")
