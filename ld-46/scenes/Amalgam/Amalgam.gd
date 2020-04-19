extends KinematicBody2D

# Disclaimer: This is very naive code, but it should work for a prototype


var block_grid = {}

const cell_length = 5.0
const cell_dim = Vector2(cell_length, cell_length)
const block_sprite = preload("res://scenes/BlockSprite/BlockSprite.tscn")
const base_polygon = PoolVector2Array([ \
	Vector2(0,0), Vector2(0,0), Vector2(0,0)])
const offsets = [ \
	Vector2(-1,  0), \
	Vector2( 0, -1), \
	Vector2( 1,  0), \
	Vector2( 0,  1)]


func add_block_global(type, world_pos):
	add_block_local(type, to_local(world_pos))

func add_block_local(type, local_pos, correct_pos=true):
	var grid_pos = local_to_grid(local_pos)
	if block_grid.has(grid_pos):
		print("Warning: Attempted to add block to filled cell")
		return
	
	if correct_pos:
		grid_pos = correct_grid_pos(grid_pos)
	
	# Create sprite
	var new_block_sprite = block_sprite.instance()
	new_block_sprite.position = grid_to_local(grid_pos)
	add_child(new_block_sprite)
	
	# Create and append block cell
	var block_cell = \
		BlockCell.new(grid_pos, type, new_block_sprite, cell_length)
	block_grid[grid_pos] = block_cell
	
	recalculate_collision_shape()

func correct_grid_pos(grid_pos):
	var empty = []
	for offset in offsets:
		var offset_pos = grid_pos + offset
		if block_grid.has(offset_pos):
			return grid_pos
		empty.append(offset_pos)
	
	for empty_pos in empty:
		for offset in offsets:
			var offset_pos = empty_pos + offset
			if block_grid.has(offset_pos):
				return empty_pos
	
	print("No viable adjustment found")

func remove_block_in_cell(cell_pos):
	var remain = {}
	var remove = {}
	for cell_pos in block_grid:
		var cell = block_grid[cell_pos]
		if cell.pos == cell_pos:
			remove[cell_pos] = cell
		else:
			remain[cell_pos] = cell
	
	for cell_pos in remove:
		var cell = block_grid[cell_pos]
		remove_child(cell.node)
		cell.node.queue_free()
	
	block_grid = remain
	recalculate_collision_shape()

func recalculate_collision_shape():
	var new_polygon = base_polygon
	for cell_pos in block_grid:
		var cell = block_grid[cell_pos]
		var polygons = Geometry.merge_polygons_2d(new_polygon, cell.polygon)
		new_polygon = polygons[0]		
		for polygon in polygons:
			if !Geometry.is_polygon_clockwise(polygon):
				new_polygon = polygon
	$CollisionPolygon2D.set_polygon(new_polygon)

func local_to_grid(pos):
	return (pos / cell_dim + Vector2(0.5,0.5)).floor()

func grid_to_local(cell):
	return cell * cell_dim

func handle_block_collision(_amalgam, block):
	add_block_global(block.type, block.position)
	block.schedule_removal()

func _ready():
	add_block_local("center", Vector2(0,0), false)


#func _process(delta):
#	pass
