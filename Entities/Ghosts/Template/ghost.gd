class_name Ghost extends Area2D

var graph: Dictionary
var tilemap: TileMapLayer

var curr_direction: Vector2i = Vector2i(1,0)

var scatter_position: Vector2i
var return_position: Vector2i

var grid_position: Vector2i
var target_grid_position: Vector2i
var next_tile = null

var house_path: Array
var curr_index: int = 1

var chase_time: float = 10
var scatter_time: float = 15
var frightened_time: float = 10
var curr_time: float = 0.0

enum GHOSTSTATE {CHASE, SCATTER, FRIGHTEND, HOUSETRAVERSAL, RETURNING, TRANSITIONING}
var curr_ghost_state: GHOSTSTATE
var prev_ghost_state: GHOSTSTATE

var speed: int = 100
@onready var colorTween: Tween = get_tree().create_tween()
var original_color: Color = modulate

func setup(spawn_position: Vector2, scatter_position: Vector2): # needs to be called before it is added to the scene tree
	var mapData = GameManager.get_map_data()
	graph = mapData.get("graph")
	tilemap = mapData.get("tilemap")
	self.position = tilemap.map_to_local(tilemap.local_to_map(spawn_position))
	self.scatter_position = tilemap.local_to_map(scatter_position)
	self.return_position = tilemap.local_to_map(spawn_position)
	self.grid_position = tilemap.local_to_map(position)
	self.house_path = BFS(tilemap.local_to_map(spawn_position), tilemap.local_to_map(Vector2(335,335)), graph)
	traverse_house()
	find_next_tile()
	

func _process(delta: float) -> void:
	if GameManager.get_state() != GameManager.STATE.GAME:
		return
		
	curr_time += delta
	
	match curr_ghost_state:
		GHOSTSTATE.CHASE:
			if curr_time > chase_time:
				scatter()
		GHOSTSTATE.SCATTER:
			if curr_time > scatter_time:
				chase()
		GHOSTSTATE.FRIGHTEND:
			if curr_time > frightened_time:
				chase()
		GHOSTSTATE.HOUSETRAVERSAL:
			if position.distance_to(tilemap.map_to_local(house_path[house_path.size() - 1])) < 4.0:
				chase()
		GHOSTSTATE.RETURNING:
			if position.distance_to(tilemap.map_to_local(return_position)) < 4.0:
				traverse_house()
	
	var next_pos = tilemap.map_to_local(next_tile)
	
	if position.distance_to(next_pos) < 4.0:
		position = next_pos
		curr_direction = next_tile - grid_position
		grid_position = tilemap.local_to_map(position)
		next_tile = null
		if grid_position == tilemap.local_to_map(Vector2(-16,400)):
			position = tilemap.local_to_map(tilemap.map_to_local(Vector2(680,400)))
			grid_position = tilemap.local_to_map(position)
			next_tile = tilemap.local_to_map(Vector2(656, 400))
		elif grid_position == tilemap.local_to_map(Vector2(680,400)):
			position = tilemap.local_to_map(tilemap.map_to_local(Vector2(-16,400)))
			grid_position = tilemap.local_to_map(position)
			next_tile = tilemap.local_to_map(Vector2(16, 400))
		else:
			find_next_tile()
			assert(next_tile != null, "placed on unconnected, or unwalkable tile")
	else:
		position = position.move_toward(next_pos, speed * delta)
	
	
func find_next_tile() -> void:
	if is_traversing_house():
		next_tile = house_path[curr_index]
		curr_index = (curr_index + 1) % house_path.size()
	else:
		for neighbor in graph[grid_position]:
			if check_dir(neighbor) and check_home(neighbor):
				if next_tile == null:
					next_tile = neighbor
				else:
					var new_distance = tilemap.map_to_local(neighbor).distance_to( tilemap.map_to_local(target_grid_position)) 
					var best_distance = tilemap.map_to_local(next_tile).distance_to(tilemap.map_to_local(target_grid_position))
					if new_distance <= best_distance:
						next_tile = neighbor
	

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
	
func scatter() -> void:
	speed = 100
	set_state(GHOSTSTATE.SCATTER)
	target_grid_position = scatter_position
	
func chase() -> void:
	speed = 100
	set_state(GHOSTSTATE.CHASE)
	recalculate_chase_target()

func frighten() -> void:
	speed = 50
	set_state(GHOSTSTATE.FRIGHTEND)
	var positions: Array = graph.keys()
	var random_pos = positions[randi_range(0, positions.size() - 1)]
	target_grid_position = random_pos

func traverse_house() -> void:
	self.scale = Vector2(1,1)
	speed = 100
	set_state(GHOSTSTATE.HOUSETRAVERSAL)

func return_home() -> void:
	speed = 300
	self.scale = Vector2(0.5,0.5)
	set_state(GHOSTSTATE.RETURNING)
	target_grid_position = return_position

func check_dir(neighbor: Vector2i) -> bool:
	return neighbor != grid_position + curr_direction * -1 or is_frightened()

func check_home(neighbor: Vector2i) -> bool:
	return neighbor != tilemap.local_to_map(Vector2(330,370)) or is_returning()

func is_frightened() -> bool:
	return curr_ghost_state == GHOSTSTATE.FRIGHTEND
	
func is_returning() -> bool:
	return curr_ghost_state == GHOSTSTATE.RETURNING

func is_traversing_house() -> bool:
	return curr_ghost_state == GHOSTSTATE.HOUSETRAVERSAL
		
func recalculate_chase_target() -> void:
	pass


func set_state(new_state: GHOSTSTATE) -> void:
	if curr_ghost_state != new_state:
		curr_time = 0
		prev_ghost_state = curr_ghost_state
		curr_ghost_state = new_state
		handle_animation()
		
func handle_animation():
	match curr_ghost_state:
		GHOSTSTATE.FRIGHTEND:
			tween_the_color()
		_:
			if is_instance_valid(colorTween):
				colorTween.kill()
			modulate = original_color

func tween_the_color():
	if is_instance_valid(colorTween):
		colorTween.kill()
	
	colorTween = get_tree().create_tween()
	colorTween.set_loops() # Loop infinitely
	colorTween.tween_property(self, "modulate", Color(0, 0, 1), 0.25)
	colorTween.tween_property(self, "modulate", Color(1, 1, 1), 0.25)
