extends Node2D


func _ready():
	$Score.text = str(Score.score)
	$ReadySound.play()

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		get_tree().change_scene("res://scenes/Title/Title.tscn")
