extends Node2D


export(float) var radius = 75
# in radians
export(float) var speed = 2

# in radians
var cur_rot = 0
onready var sprite = $Sprite

const TWO_PI = 2 * PI


func _ready():
	sprite.position = Vector2(radius, 0)

func _process(delta):
	# Input
	if Input.is_action_pressed("ui_left"):
		cur_rot += speed * delta
	elif Input.is_action_pressed("ui_right"):
		cur_rot -= speed * delta
	
	# Logic
	if cur_rot < 0:
		cur_rot += TWO_PI
	elif cur_rot > TWO_PI:
		cur_rot -= TWO_PI
	
	var sprite_pos = \
		Vector2(sin(cur_rot) * radius, cos(cur_rot) * radius)
	
	sprite.position = sprite_pos
	sprite.rotation = -cur_rot
