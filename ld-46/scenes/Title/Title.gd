extends Node2D


func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		$StartSound.play()
		get_tree().change_scene("res://scenes/Arena/Arena.tscn")
