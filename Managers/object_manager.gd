class_name ObjectManager extends Node

const CYAN_GHOST = preload("res://Entities/Ghosts/Cyan/CyanGhost.tscn")
const ORANGE_GHOST = preload("res://Entities/Ghosts/Orange/OrangeGhost.tscn")
const PINK_GHOST = preload("res://Entities/Ghosts/Pink/PinkGhost.tscn")
const RED_GHOST = preload("res://Entities/Ghosts/Red/RedGhost.tscn")
const PACMAN = preload("res://Entities/Pacman/Pacman.tscn")
const MAIN_MENU = preload("res://UI/MainMenu.tscn")
const TEST_GHOST = preload("res://Entities/Ghosts/TestGhost/TestGhost.tscn")

var GHOST_SCENES: Dictionary = {
	"red": RED_GHOST,
	"pink": PINK_GHOST,
	"orange": ORANGE_GHOST,
	"cyan": CYAN_GHOST
}

var ghost_map: Dictionary = {}

var pacman: Pacman
var main_menu: MainMenu

var root: Game

func _init(root: Game) -> void:
	self.root = root
	
func create_ghosts(
	ghost_types: Array[String] = ["red", "pink", "orange", "cyan"],
	spawn_positions: Array[Vector2] = [Vector2(300, 400), Vector2(330, 400), Vector2(360, 400), Vector2(336, 368)],
	scatter_positions: Array[Vector2] = [Vector2(-35, 25), Vector2(745,10), Vector2(745,835), Vector2(-100,835)]
) -> void:
	
	assert(
		ghost_types.size() == spawn_positions.size() and ghost_types.size() == scatter_positions.size(),
		"create_ghosts(): size mismatch"
	)

	for i in ghost_types.size():
		var ghost_name = ghost_types[i]
		var ghost_scene: PackedScene = GHOST_SCENES.get(ghost_name)
		assert(ghost_scene != null, "No ghost scene for: %s" % ghost_name)

		var ghost: Ghost = ghost_scene.instantiate() as Ghost
		ghost.setup(spawn_positions[i], scatter_positions[i])
		ghost.connect("body_entered", handle_ghost_body_entered.bind(ghost))
		root.add_child(ghost)
	
		ghost_map[ghost_name] = ghost
	
func create_pacman(position: Vector2 = Vector2(338,593), direction: Vector2i = Vector2i(0,1)) -> void:
	pacman = PACMAN.instantiate()
	#connect_pacman_signals()
	pacman.setup(position, direction)
	root.add_child(pacman)

func create_main_menu() -> void:
	main_menu = MAIN_MENU.instantiate()
	#connect_main_menu_signals()
	root.add(main_menu)

func create_test_ghost(position: Vector2, scatter_position: Vector2) -> void:
	var test_ghost = TEST_GHOST.instantiate()
	test_ghost.setup(position, scatter_position)
	root.add_child(test_ghost)
	
func clear_obejcts() -> void:
	(ghost_map["red"] as Ghost).queue_free()
	(ghost_map["orange"] as Ghost).queue_free()
	(ghost_map["pink"] as Ghost).queue_free()
	(ghost_map["cyan"] as Ghost).queue_free()
	pacman.queue_free()

func delete_main_menu() -> void:
	main_menu.queue_free()
	
func connect_pellet_signals() -> void:
	for small_pellet in root.get_tree().get_nodes_in_group("SmallPelletGroup"):
		small_pellet.connect("body_entered", handle_small_pellet_collection.bind(small_pellet), CONNECT_ONE_SHOT)
		
	for power_pellet in root.get_tree().get_nodes_in_group("BigPelletGroup"):
		power_pellet.connect("body_entered", handle_power_pellet_collection.bind(power_pellet), CONNECT_ONE_SHOT)
	
#func connect_pacman_signal() -> void:
	#pass

#func connect_ghost_signal() -> void:
	#for ghost in root.get_tree().get_nodes_in_group("Ghosts"):
		#ghost.connect("body_entered", handle_ghost_body_entered.bind(ghost))

#func connect_main_menu_signals() -> void:
	#pass

func handle_small_pellet_collection(body, small_pellet: Node2D) -> void:
	GameManager.uiManager.update_score(100)
	small_pellet.pellet.visible = false

func handle_power_pellet_collection(body, power_pellet: Node2D) -> void:
	GameManager.uiManager.update_score(500)
	power_pellet.pellet.visible = false
	frighten_all_ghosts()

func frighten_all_ghosts():
	for ghost in root.get_tree().get_nodes_in_group("Ghosts"):
		ghost = ghost as Ghost
		if !ghost.is_traversing_house():
			ghost.frighten()

func handle_ghost_body_entered(body, ghost: Ghost) -> void:
	match ghost.curr_ghost_state:
		ghost.GHOSTSTATE.RETURNING:
			pass
		ghost.GHOSTSTATE.HOUSETRAVERSAL:
			pass
		ghost.GHOSTSTATE.FRIGHTEND:
			handle_ghost_death(ghost)
		_:
			handle_pac_death()

func handle_ghost_death(ghost: Ghost):
	GameManager.uiManager.update_score(1000)
	ghost.return_home()

func handle_pac_death():
	print("dead")
