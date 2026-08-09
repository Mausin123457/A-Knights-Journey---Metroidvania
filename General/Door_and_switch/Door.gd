@icon("res://General/Icons/door.svg")
@tool
class_name Door extends Node2D

#NEED TO HAVE AN ACTUAL AUDIO HERE!!
const DOOR_CRASH_AUDIO = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for c in get_children():
		if c is Switch:
			c.activated.connect(on_switch_activated)
			if c.is_open == true:
				on_switch_is_open()
	pass

func on_switch_activated() -> void:
	#Play audio here!
	
	animation_player.play("Opening")
	pass

func on_switch_is_open() -> void:
	animation_player.play("Open")
	pass


func _get_configuration_warnings() -> PackedStringArray:
	if check_for_switch() == false:
		return ['Requires a Switch node.']
	return []

func check_for_switch() -> bool:
	for c in get_children():
		if c is Switch:
			return true
	return false
