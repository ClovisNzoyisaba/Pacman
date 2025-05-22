class_name MapManager extends Node
# map manager updates graph

var tile_map_layer: TileMapLayer
var graph: Dictionary = {}

func _init(tile_map_layer: TileMapLayer) -> void:
	self.tile_map_layer = tile_map_layer
	build_graph()
	
func build_graph() -> void:
	for cell in tile_map_layer.get_used_cells():
		if is_walkable(cell):
			var neighbors = []
			for offset in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
				var neighbor = cell + offset
				if is_walkable(neighbor):
					neighbors.append(neighbor)
					graph[cell] = neighbors
	
func is_walkable(coord: Vector2i) -> bool:
	var tile_id = tile_map_layer.get_cell_source_id(coord)  # <-- this is the internal tile ID
	return tile_id == 1
	

	
