class_name RedGhost extends Ghost

func recalculate_chase_path():
	var start_tile = tilemap.local_to_map(position)
	var target_tile = GameManager.get_pacman_grid_position()
	curr_path = BFS(start_tile, target_tile, graph)
	curr_path_index = 0
