@icon("res://General/Icons/input_hints.svg")
class_name InputHints extends Node2D

const HINT_MAP: Dictionary = {
	"keyboard" : {
		"interact" : 15,
		"attack" : 22,
		"jump" : 27,
		"dash" : 23,
		"up" : 13,
		"parry" : 16,
		"map" : 14,
	},
	"playstation" : {
		"interact" : 0,
		"attack" : 2,
		"jump" : 1,
		"dash" : 17,
		"up" : 4,
		"parry" : 20,
		"map" : 21,
	},
	"xbox" : {
		"interact" : 8,
		"attack" : 7,
		"jump" : 5,
		"dash" : 18,
		"up" : 4,
		"parry" : 24,
		"map" : 21,
	}
}

@onready var sprite_2d: Sprite2D = $Sprite2D

var controller_type: String = "keyboard"


func _ready() -> void:
	visible = false
	Messages.input_hint_changed.connect(on_hint_changed)
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		controller_type = "keyboard"
	elif event is InputEventJoypadButton:
		get_controller_type(event.device)
	pass


func get_controller_type(device_id: int) -> void:
	var n: String = Input.get_joy_name(device_id).to_lower()
	
	if "xbox" in n:
		controller_type = "xbox"
	elif "playstation" in n or "ps" in n or "dualsense" in n:
		controller_type = "playstation"
	elif "nintendo" in n or "switch" in n:
		controller_type = "xbox"
	else:
		controller_type = "unknown"
	
	set_process_input(false)
	
	pass


func on_hint_changed(hint: String) -> void:
	if hint == "":
		visible = false
	else:
		visible = true
		sprite_2d.frame = HINT_MAP[controller_type].get(hint, "0")
	pass
