class_name SmallPelletTile extends Area2D

signal pellet_consumed(pellet)

@onready var pellet: Polygon2D = $Pellet

func _on_body_entered(body: Node2D) -> void:
	pellet_consumed.emit(pellet)
