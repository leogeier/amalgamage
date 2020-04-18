extends KinematicBody2D


var velocity = 0
var direction = Vector2()


func _ready():
	pass # Replace with function body.

func _process(delta):
	var collision = move_and_collide(velocity * direction * delta)
	if collision:
		print("collided!")
