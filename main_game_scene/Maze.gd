extends Node2D # maze gen code from KidsCanCode on YouTube - Procedural Content Generation Part 1

const N = 1 # 0001
const E = 2 # 0010
const S = 4 # 0100
const W = 8 # 1000

const tile_size = 384
const start_size = 5
var width = 5
var height = 5

var passes: int = 0

@export var Map: TileMap
var map_layer = 0
var starting_spot = Vector2(0, 0)

@export var Player: CharacterBody2D
@export var Cam: Camera2D

@export var Portal: PackedScene # object takes player to next maze

var current_portal_inst # will store reference to the portal spawned in

# Dictionary with vectors corresponding to the directions
var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E,
				  Vector2(0, 1): S, Vector2(-1, 0): W}


# Called when the node enters the scene tree for the first time.
func _ready():
	level_gen()

# create a level
func level_gen():
	randomize()
	
	width = start_size + (passes / 2)
	height = start_size + (passes / 2)
	Cam.limit_right = width * tile_size
	Cam.limit_bottom = height * tile_size
	
	# read saved data
	starting_spot = Vector2(randi_range(0, width - 1), randi_range(0, height - 1)) # randomize start spot
	Player.position = to_global(Map.map_to_local(starting_spot)) # teleport player to starting place
	Player.get_node("Camera2D").reset_smoothing() # prevent camera from sliding over to player from prev pos
	
	make_maze()
	
	current_portal_inst.player_entered_portal.connect(_on_player_entered_portal)

func make_portal(pos:Vector2):
	var new_portal:Node = Portal.instantiate()
	new_portal.position = pos
	add_child(new_portal)
	current_portal_inst = new_portal
	if current_portal_inst == null:
		print("ERROR: current_portal_inst is null")

func destroy_portal():
	remove_child(current_portal_inst)
	current_portal_inst.queue_free()

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
	var placed_portal: bool = false
	# first we fill the map with solid tiles
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y)) # add every tile to unvisited
			Map.set_cell(map_layer, Vector2(x, y), 0, id_to_coords(N|E|S|W)) # set tile to 15 (the solid one)
	var current = starting_spot
	unvisited.erase(current) # current tile is now visited
	
	var portal_tile # this will store tile coords of portal
	
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
			
			if not placed_portal:
				portal_tile = current # save this location for placing portal
			
		elif stack: # no neighbors to go to, but somethings in the stack
			if not placed_portal:
				var portal_position = to_global(Map.map_to_local(portal_tile)) # calculate where to spawn the portal in
				make_portal(portal_position)
				placed_portal = true
			current = stack.pop_back()

func _on_player_entered_portal():
	passes += 1
	destroy_portal()
	# TODO: do save data right here or something
	level_gen()

