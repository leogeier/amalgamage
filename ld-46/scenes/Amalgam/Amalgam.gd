extends RigidBody2D

# Disclaimer: This is very naive code, but it should work for a prototype


var block_grid = {}
var last_shape_offset = Vector2(0,0)
var last_center_sum = Vector2(0,0)
var game_over = false
var game_over_start
var game_over_duration = 3000
var border

const cell_length = 8.0
const cell_dim = Vector2(cell_length, cell_length)
const block_sprite = preload("res://scenes/BlockSprite/BlockSprite.tscn")
const base_polygon = PoolVector2Array([ \
	Vector2(0,0), Vector2(0,0), Vector2(0,0)])
const offsets = [ \
	Vector2(-1,  0), \
	Vector2( 0, -1), \
	Vector2( 1,  0), \
	Vector2( 0,  1)]
const block_weight = 1


func add_block_global(type, world_pos):
	add_block_local(type, $CollisionPolygon2D.to_local(world_pos))

func add_block_local(type, local_pos, correct_pos=true):
	var grid_pos = local_to_grid(local_pos)
	if block_grid.has(grid_pos):
		print("Warning: Attempted to add block to filled cell. local_pos: ", local_pos, ", grid_pos: ", grid_pos)
		return false
	
	if correct_pos:
		grid_pos = correct_grid_pos(grid_pos)
	
	# Create sprite
	var new_block_sprite = block_sprite.instance()
	var centered_local_pos = grid_to_local(grid_pos)
	new_block_sprite.position = centered_local_pos
	#new_block_sprite.hide()
	$Sprites.add_child(new_block_sprite)
	
	# Create and append block cell
	var block_cell = \
		BlockCell.new(grid_pos, type, new_block_sprite, cell_length)
	block_grid[grid_pos] = block_cell
	
	mass += block_weight
	recalculate_collision_shape()
	# Dirty hacks to ensure rotation around center of mass
	var grid_size = block_grid.size()
	var new_center_sum = last_center_sum + centered_local_pos
	var new_shape_offset = new_center_sum / grid_size
	var delta_offset = new_shape_offset - last_shape_offset
	$Sprites.position -= delta_offset
	$CollisionPolygon2D.position -= delta_offset
	position += delta_offset
	last_center_sum = new_center_sum
	last_shape_offset = new_shape_offset
	return true

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

func remove_block_in_cell(remove_cell_pos):
	var remain = {}
	var remove = {}
	for cell_pos in block_grid:
		var cell = block_grid[cell_pos]
		if cell.pos == remove_cell_pos:
			remove[cell_pos] = cell
		else:
			remain[cell_pos] = cell
	
	for cell_pos in remove:
		var cell = block_grid[cell_pos]
		$Sprites.remove_child(cell.node)
		cell.node.queue_free()
	
	block_grid = remain
	recalculate_collision_shape()
	
	mass -= block_weight
	# Dirty hacks to ensure rotation around center of mass
	# TODO: less duplication
	var grid_size = block_grid.size()
	var new_center_sum = last_center_sum - grid_to_local(remove_cell_pos)
	var new_shape_offset = new_center_sum / grid_size
	var delta_offset = new_shape_offset - last_shape_offset
	recalculate_collision_shape()
	$Sprites.position -= delta_offset
	$CollisionPolygon2D.position -= delta_offset
	position += delta_offset
	last_center_sum = new_center_sum
	last_shape_offset = new_shape_offset

func recalculate_collision_shape():
	var new_polygon = base_polygon
	for cell_pos in block_grid:
		var cell = block_grid[cell_pos]
		var polygons = Geometry.merge_polygons_2d(new_polygon, cell.polygon)
		new_polygon = polygons[0]	
		for polygon in polygons:
			if !Geometry.is_polygon_clockwise(polygon):
				new_polygon = polygon
	
	$CollisionPolygon2D.polygon = new_polygon

func local_to_grid(pos):
	return (pos / cell_dim + Vector2(0.5,0.5)).floor()

func grid_to_local(cell):
	return cell * cell_dim

func handle_block_collision(_amalgam, block):
	var block_pos = block.position
	add_block_global(block.type, block_pos)
	block.schedule_removal()
	
	var impulse_offset = to_local(block.to_global(block_pos))
	# TODO better impulse calc
	$AttachSound.play()
	var success = apply_impulse(impulse_offset, block.direction * 10)
	if success:
		Score.score += 1

func _ready():
	mass = 0.00001
	inertia = 1000
	add_block_local("center", Vector2(0,0), false)
	var border_group = get_tree().get_nodes_in_group("border")
	if !border_group.empty():
		border = border_group[0]

func _process(delta):
	if border == null:
		return
	
	if !game_over and \
		(border.position - position).length() > border.radius:
		game_over = true
		$GameOverSprite.show()
		$GameOverSound.play()
		game_over_start = OS.get_ticks_msec()
	
	if game_over:
		if $GameOverSprite.scale.x < 3:
			$GameOverSprite.scale *= 1.15
		else:
			$GameOverSprite.position = to_local(Vector2())
		if game_over_start + game_over_duration < OS.get_ticks_msec():
			get_tree().change_scene("res://scenes/GameOver/GameOver.tscn")
