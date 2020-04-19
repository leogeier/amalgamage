extends Area2D


var velocity = 0
var direction = Vector2()
var type = "normal"
var remove = false


func schedule_removal():
	remove = true

func _ready():
	var amalgam_group = get_tree().get_nodes_in_group("amalgam")
	if !amalgam_group.empty():
		var amalgam = amalgam_group[0]
		connect("body_entered", amalgam, "handle_block_collision", [self])

func _process(delta):
	position +=  velocity * direction * delta
	
	if remove:
		get_parent().remove_child(self)
		queue_free()
