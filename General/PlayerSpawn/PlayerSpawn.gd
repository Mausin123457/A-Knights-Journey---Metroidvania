@icon("res://General/Icons/player_spawn.svg")
class_name PlayerSpawn extends Node2D


func _ready() -> void:
	visible = false
	await get_tree().process_frame
	
	
	
	
	pass
