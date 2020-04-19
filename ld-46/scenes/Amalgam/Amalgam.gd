extends KinematicBody2D

# Disclaimer: This is very naive code, but it should work for a prototype


var block_grid = []

const cell_length = 5.0
const cell_dim = Vector2(cell_length, cell_length)
const block_sprite = preload("res://scenes/BlockSprite/BlockSprite.tscn")
const base_polygon = PoolVector2Array([ \
	Vector2(0,0), Vector2(0,0), Vector2(0,0)])


func add_block_global(type, world_pos):
	add_block_local(type, to_local(world_pos))

func add_block_local(type, local_pos):
	# Create sprite
	var grid_pos = local_to_grid(local_pos)
	
	var new_block_sprite = block_sprite.instance()
	new_block_sprite.position = grid_to_local(grid_pos)
	add_child(new_block_sprite)
	
	# Create and append block cell
	var block_cell = \
		BlockCell.new(grid_pos, type, new_block_sprite, cell_length)
	block_grid.append(block_cell)
	
	recalculate_collision_shape()

func remove_block_in_cell(cell_pos):
	var remain = []
	var remove = []
	for cell in block_grid:
		if cell.pos == cell_pos:
			remove.append(cell)
		else:
			remain.append(cell)
	
	for cell in remove:
		remove_child(cell.node)
		cell.node.queue_free()
	
	block_grid = remain
	recalculate_collision_shape()

func recalculate_collision_shape():
	var new_polygon = base_polygon
	for cell in block_grid:
		new_polygon = Geometry.merge_polygons_2d(new_polygon, cell.polygon)[0]
	$CollisionPolygon2D.set_polygon(new_polygon)

func local_to_grid(pos):
	return (pos / cell_dim + Vector2(0.5,0.5)).floor()

func grid_to_local(cell):
	return cell * cell_dim

func handle_block_collision(_amalgam, block):
	add_block_global(block.type, block.position)

func _ready():
	add_block_local("center", Vector2(0,0))


#func _process(delta):
#	pass
