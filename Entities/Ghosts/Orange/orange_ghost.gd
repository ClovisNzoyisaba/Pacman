class_name OrangeGhost extends RedGhost

func recalculate_chase_target():
	super.recalculate_chase_target()
	var dist = manhattan_distance(grid_position, GameManager.get_pacman_grid_position())
	if dist < 4:
		scatter()
	
func manhattan_distance(a: Vector2i, b: Vector2i) -> int:
	return abs(a.x - b.x) + abs(a.y - b.y)	
