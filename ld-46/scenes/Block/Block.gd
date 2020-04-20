extends Area2D


var velocity = 0
var direction = Vector2()
var sprite_rot_speed = 0
var type = "normal"
var remove = false

const max_rot_speed = .05


func schedule_removal():
	remove = true

func _ready():
	var amalgam_group = get_tree().get_nodes_in_group("amalgam")
	if !amalgam_group.empty():
		var amalgam = amalgam_group[0]
		connect("body_entered", amalgam, "handle_block_collision", [self])
	
	sprite_rot_speed = rand_range(-max_rot_speed, max_rot_speed)

func _process(delta):
	position +=  velocity * direction * delta
	
	if remove:
		get_parent().remove_child(self)
		queue_free()
	
	$BlockSprite.rotate(sprite_rot_speed)
