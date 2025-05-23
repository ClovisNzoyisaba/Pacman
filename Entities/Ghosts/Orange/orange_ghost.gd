class_name OrangeGhost extends RedGhost

func _process(delta: float) -> void:
	super._process(delta)
	if (BFS(get_grid_position(position), GameManager.get_pacman_grid_position(), graph).size() < 4):
		set_state(GHOSTSTATE.SCATTER)
		recalculate_scatter_path()
		curr_time = 0	
