class_name PinkGhost extends Ghost

var time_until_recalculation: float = 3.0
var curr_time: float = 0.0
var current_index: int = 0

func setup(position: Vector2):
	super.setup(position)
	recalculate_path()

func _process(delta: float) -> void:
	curr_time += delta
	if curr_time > time_until_recalculation:
		curr_time = 0.0
		recalculate_path()
	
	if curr_path.size() < 2:
		return  # No movement needed

	if current_index + 1 >= curr_path.size():
		return  # Already at end of path

	var next_tile = curr_path[current_index + 1]
	var next_pos = tilemap.map_to_local(next_tile)

	position = position.move_toward(next_pos, speed * delta)

	if position.distance_to(next_pos) < 1.0:
		position = next_pos
		current_index += 1

func recalculate_path():
	var start_tile = tilemap.local_to_map(position)
	var target_tile = GameManager.get_pacman_grid_position()
	var pacman_curr_dir = GameManager.get_pacman_curr_dir()
	var tiles_ahead = 8
	for i in tiles_ahead:
		var check_pos = target_tile + Vector2i(pacman_curr_dir)
		if graph[target_tile].has(check_pos):
			target_tile = check_pos
		else:
			target_tile = graph[target_tile][randi_range(0, graph[target_tile].size() - 1)]		
			
	curr_path = BFS(start_tile, target_tile, graph)
	current_index = 0
