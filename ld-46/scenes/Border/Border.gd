extends Node2D


export(float) var radius = 150
export(int) var num_sprites = 100


func _ready():
	$Area2D/CollisionShape2D.shape.radius = radius
	
	$ProtoAnimation/AnimatedSprite.position = Vector2(radius, 0)
	var angle_delta = 2 * PI / num_sprites
	for i in range(num_sprites):
		var new_sprite = $ProtoAnimation.duplicate()
		new_sprite.rotate(i * angle_delta)
		add_child(new_sprite)
	
	$ProtoAnimation.hide()
