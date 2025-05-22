class_name Ghost extends Area2D

var graph: Dictionary
var tilemap: TileMapLayer
var curr_path: Array
var speed: int = 100

enum GHOSTSTATE {NORMAL, EATABLE}
var curr_ghost_state: GHOSTSTATE

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	
func scatter(position: Vector2) -> void:
	speed = 200
	curr_path = BFS(tilemap.local_to_map(self.position), tilemap.local_to_map(position), graph)
	
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

func setup(position: Vector2):
	graph = GameManager.getGraph()
	tilemap = GameManager.getTileMap()
	self.position = tilemap.map_to_local(tilemap.local_to_map(position))
	
func _on_body_entered(body: Node) -> void:
	print("collision")
