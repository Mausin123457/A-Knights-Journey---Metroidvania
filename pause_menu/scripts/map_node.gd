@tool
@icon("res://General/Icons/map_node.svg")
class_name MapNode extends Control

const SCALE_FACTOR: float = 40.0

#variables

@onready var label: Label = $Label
@onready var transition_blocks: Control = %TransitionBlocks


func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		label.queue_free()
		#create and display transition blocks
	pass 



func _process(delta: float) -> void:
	pass
