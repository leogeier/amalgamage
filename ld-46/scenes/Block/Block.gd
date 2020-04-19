extends Area2D


var velocity = 0
var direction = Vector2()
var type = "normal"


func _ready():
	var amalgam_group = get_tree().get_nodes_in_group("amalgam")
	if !amalgam_group.empty():
		var amalgam = amalgam_group[0]
		connect("body_entered", amalgam, "handle_block_collision", [self])

func _process(delta):
	position +=  velocity * direction * delta
