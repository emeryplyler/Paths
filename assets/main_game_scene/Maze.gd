extends Node2D # code from KidsCanCode on YouTube - Procedural Content Generation Part 1

const N = 1 # 0001
const E = 2 # 0010
const S = 4 # 0100
const W = 8 # 1000

#var tile_size = 384
var width = 5
var height = 5

@export var Map: TileMap
var map_layer = 0
var starting_spot = Vector2(0, 0)

# Dictionary with vectors corresponding to the directions
var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E,
				  Vector2(0, 1): S, Vector2(-1, 0): W}


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	# Map.set_cell(map_layer, Vector2(0, 0), 0, id_to_coords(N|E|S|W))
	# var test:int = coords_to_id(Map.get_cell_atlas_coords(map_layer, Vector2(0, 0)))
	make_maze()

# small functions because tilesets work differently in godot 4 than 3
func id_to_coords(id:int):
	return Vector2(id % 4, ceil(id/4))

# REMEMBER: this one converts ATLAS COORDINATES into an id
# call get_cell_atlas_coords on the map coordinates BEFORE using this
func coords_to_id(coords:Vector2):
	return coords.x + coords.y * 4
	
# returns array of cell's unvisited neighbors
# unvisited is the array of all tiles in the maze not reached yet
func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys(): # n will be one of the vectors
		if cell + n in unvisited: # add vector to current coordinates of cell
			list.append(cell + n)
	return list

func make_maze():
	var unvisited = []
	var stack = [] # homemade stack structure
	# first we fill the map with solid tiles
	Map.clear() # NOTE: clears tilemap; may interfere with future plans?
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y)) # add every tile to unvisited
			Map.set_cell(map_layer, Vector2(x, y), 0, id_to_coords(N|E|S|W)) # set tile to 15 (the solid one)
	var current = starting_spot
	unvisited.erase(current) # current tile is now visited
	
	# recursive backtracker algorithm:
	while unvisited: # while unvisited not empty
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()] # pick random neighbor to go to next
			stack.append(current)
			# remove walls from both cells
			var dir = next - current # subtract coordinates; this gives us a vector
			var current_walls = coords_to_id(Map.get_cell_atlas_coords(map_layer, current)) - cell_walls[dir] # subtract 1 2 4 or 8 from id (up to 15) of tile
			var next_walls = coords_to_id(Map.get_cell_atlas_coords(map_layer, next)) - cell_walls[-dir] # the subtraction turns it into a different shape tile
			Map.set_cell(map_layer, current, 0, id_to_coords(current_walls)) # set tiles to new correct shape
			Map.set_cell(map_layer, next, 0, id_to_coords(next_walls))
			current = next
			unvisited.erase(current) # we have visited a new tile
		elif stack: # no neighbors to go to, but somethings in the stack
			current = stack.pop_back()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
