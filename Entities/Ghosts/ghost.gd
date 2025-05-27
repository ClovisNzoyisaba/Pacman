class_name Ghost2 extends Area2D

signal no_longer_frightend

var graph: Dictionary
var tilemap: TileMapLayer
var curr_path: Array

var scatter_position: Vector2
var return_position: Vector2
var grid_position: Vector2i

var chase_time: float = 10
var scatter_time: float = 20
var frightened_time: float = 10
var curr_time: float = 0.0
var curr_path_index: int = 0

var speed: int = 100

enum GHOSTSTATE {CHASE, SCATTER, FRIGHTEND, RETURNING}
var curr_ghost_state: GHOSTSTATE = GHOSTSTATE.CHASE

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	self.add_to_group("Ghosts")

func setup(spawn_position: Vector2, scatter_position: Vector2): # needs to be called before it is added to the scene tree
	graph = GameManager.getGraph()
	tilemap = GameManager.getTileMap()
	self.position = tilemap.map_to_local(tilemap.local_to_map(spawn_position))
	self.scatter_position = tilemap.map_to_local(tilemap.local_to_map(scatter_position))
	self.return_position = tilemap.map_to_local(tilemap.local_to_map(spawn_position))
	chase()

func _process(delta: float) -> void:
	curr_time += delta
	match curr_ghost_state: 
		GHOSTSTATE.CHASE: 
			if curr_time > chase_time:
				scatter()
				curr_time = 0
			if curr_path_index + 1 >= curr_path.size(): # the end of the path, continue chasing until time is up
				chase()
		GHOSTSTATE.SCATTER: 
			if curr_time > scatter_time or curr_path_index + 1 >= curr_path.size():
				chase()
				curr_time = 0
		GHOSTSTATE.FRIGHTEND: # to be determined by the game manager
			if curr_time > frightened_time:
				no_longer_frightend.emit()
				chase()
				curr_time = 0
				
	if curr_path.size() < 2: # no movement needed, also avoids the index exception on next line
		return	
		
	var next_tile = curr_path[curr_path_index + 1]
	var next_pos = tilemap.map_to_local(next_tile)

	position = position.move_toward(next_pos, speed * delta)

	if position.distance_to(next_pos) < 4.0:
		position = next_pos
		curr_path_index += 1

func set_state(state: GHOSTSTATE) -> void:
	curr_ghost_state = state

func get_state() -> GHOSTSTATE:
	return curr_ghost_state

func chase():
	set_state(GHOSTSTATE.CHASE)
	recalculate_chase_path()
	
func scatter():
	set_state(GHOSTSTATE.SCATTER)
	recalculate_scatter_path()

func frighten():
	set_state(GHOSTSTATE.FRIGHTEND)
	recalculate_fright_path()

func reset():
	curr_time = 0
	curr_path_index = 0

func get_grid_position(position: Vector2) -> Vector2i:
	return tilemap.local_to_map(position)	
	
func recalculate_chase_path() -> void:
	pass # to be implemented by inheriting ghost

func recalculate_scatter_path() -> void:
	var start_tile: Vector2i = get_grid_position(position)
	var target_tile: Vector2i = get_grid_position(scatter_position)
	curr_path = BFS(start_tile, target_tile, graph)
	curr_path_index = 0
	
func recalculate_fright_path() -> void:
	var start_tile: Vector2i = get_grid_position(position)
	var target_tile = start_tile
	var visited = {start_tile: true}
	var path = [start_tile] # check if starting from the start tile is bad
	# random? but technically its prioritizing UP to DOWN to LEFT, etc
	for i in 32:
		for offset in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			var neighbor: Vector2i = target_tile + offset
			if !visited.has(neighbor) and graph[target_tile].has(neighbor):
				target_tile = neighbor
				visited[target_tile] = true
				path.append(neighbor)
				break
				
	curr_path = path		
	curr_path_index = 0	
	
func recalculate_return_path() -> void:
	var start_tile: Vector2i = get_grid_position(position)
	var target_tile: Vector2i = get_grid_position(return_position)
	curr_path = BFS(start_tile, target_tile, graph)
	curr_path_index = 0
	
func BFS(start: Vector2i, goal: Vector2i, graph: Dictionary) -> Array:
	var queue = [start]
	var visited = {}
	var came_from = {}
 
	visited[start] = true
	came_from[start] = null

	while queue.size() > 0:
		var current = queue.pop_front()
		if current == goal:
			break

		for neighbor in graph[current]:
			if neighbor not in visited:
				visited[neighbor] = true
				came_from[neighbor] = current
				queue.append(neighbor)

	return reconstruct_path(came_from, start, goal)
		
func reconstruct_path(came_from, start: Vector2i, goal: Vector2i) -> Array:
	var path = []
	var current = goal

	while current != null:
		path.push_front(current)
		current = came_from[current]

	return path	

func _on_body_entered(body: Node) -> void:
	pass
