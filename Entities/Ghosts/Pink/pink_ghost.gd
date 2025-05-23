class_name PinkGhost extends Ghost

func recalculate_chase_path():
	var start_tile = tilemap.local_to_map(position)
	var target_tile = GameManager.get_pacman_grid_position()
	var pacman_curr_dir = GameManager.get_pacman_curr_dir()
	var tiles_ahead = 8
	
	for i in tiles_ahead:
		var check_pos = target_tile + Vector2i(pacman_curr_dir)
		if graph[target_tile].has(check_pos):
			target_tile = check_pos
		else:
			if graph[target_tile].size() != 0:
				target_tile = graph[target_tile][randi_range(0, graph[target_tile].size() - 1)]		
			
	curr_path = BFS(start_tile, target_tile, graph)
	curr_path_index = 0
