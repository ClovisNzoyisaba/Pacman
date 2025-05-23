class_name CyanGhost extends Ghost

func recalculate_chase_path():
	var start_tile = tilemap.local_to_map(position)
	var target_tile = GameManager.get_pacman_grid_position()
	var pac_curr_dir = GameManager.get_pacman_curr_dir()
	
	var used_cells: Array = tilemap.get_used_cells()
	
	for i in 6:
		var within_bounds: bool = target_tile in used_cells
		while !graph.has(target_tile) and within_bounds:
			target_tile = target_tile + pac_curr_dir
			within_bounds = target_tile in tilemap.get_used_cells()
			
		if !within_bounds:
			break	
		
	curr_path = BFS(start_tile, target_tile, graph)
	curr_path_index = 0
