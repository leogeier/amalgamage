extends Sprite


var sprite_idx

const textures = [ \
	preload("res://scenes/BlockSprite/block1.png"), \
	preload("res://scenes/BlockSprite/block2.png"), \
	preload("res://scenes/BlockSprite/block3.png"), \
	preload("res://scenes/BlockSprite/block4.png"), \
	preload("res://scenes/BlockSprite/block5.png"), \
	preload("res://scenes/BlockSprite/block6.png") ]


func _ready():
	if sprite_idx == null:
		sprite_idx = randi() % 6
	texture = textures[sprite_idx]
