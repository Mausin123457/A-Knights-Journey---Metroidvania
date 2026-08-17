#class_name Savemanager 
extends Node

const CONFIG_FILE_PATH = "user://settings.cfg"
const SLOTS: Array[String] = [
	"Save_01",
	"Save_02",
	"Save_03"
]


var current_slot : int = 0
var save_data : Dictionary = {}
var discovered_areas : Array = []
var pending_discovered_areas : Array = []
var persistant_data : Dictionary = {}



func _ready() -> void:
	load_config()
	SceneManager.scene_entered.connect(on_scene_entered)
	pass


func create_new_game_save(slot: int) -> void:
	current_slot = slot
	discovered_areas.clear()
	pending_discovered_areas.clear()
	persistant_data.clear()
	var new_game_scene : String = "uid://cvgsrlj7isd00"
	discovered_areas.append(new_game_scene)
	
	save_data = {
		"scene_path" : new_game_scene,
		"x" : 192,
		"y" : 380,
		"hp" : 5,
		"max_hp" : 5,
		"dash" : false,
		"parry" : false,
		"wall_jump" : false,
		"discovered_areas" : discovered_areas,
		"persistant_data" : persistant_data,
	}
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	
	save_file.close()
	
	load_game(slot)
	pass


func save_game() -> void:
	var player: Player = get_tree().get_first_node_in_group("Player")
	var current_scene_uid: String = SceneManager.current_scene_uid
	if not discovered_areas.has(current_scene_uid):
		discovered_areas.append(current_scene_uid)

	for scene_uid in pending_discovered_areas:
		if not discovered_areas.has(scene_uid):
			discovered_areas.append(scene_uid)
	pending_discovered_areas.clear()

	save_data = {
		"scene_path" : current_scene_uid,
		"x" : player.global_position.x,
		"y" : player.global_position.y,
		"hp" : player.hp,
		"max_hp" : player.max_hp,
		"dash" : player.dash,
		"parry" : player.parry,
		"wall_jump" : player.wall_jump,
		"discovered_areas" : discovered_areas,
		"persistant_data" : persistant_data,
	}
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	pass


func load_game(slot: int) -> void:
	if !FileAccess.file_exists(get_file_name(current_slot)):
		return
	
	current_slot = slot
	
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.READ)
	
	save_data = JSON.parse_string(save_file.get_line())
	
	persistant_data = save_data.get("persistant_data", {})
	discovered_areas = save_data.get("discovered_areas", [])
	pending_discovered_areas.clear()
	var scene_path : String = save_data.get("scene_path", "uid://cvgsrlj7isd00" )
	SceneManager.transition_scene(scene_path, "", Vector2.ZERO, "up")
	await SceneManager.new_scene_ready
	setup_player()
	pass
	

func setup_player() -> void:
	var player: Player = null
	while not player: 
		player = get_tree().get_first_node_in_group("Player")
		await get_tree().process_frame
	
	player.max_hp = save_data.get("max_hp", 5)
	player.hp = save_data.get("hp", 5)
	
	player.dash = save_data.get("dash", false)
	player.wall_jump = save_data.get("wall_jump", false)
	player.parry = save_data.get("parry", false)
	
	player.global_position = Vector2(
		save_data.get("x", 0),
		save_data.get("y", 0)
	)
	pass


func get_file_name(slot: int) -> String:
	return "user://" + SLOTS[slot] + ".sav"


func save_file_exists(slot : int) -> bool:
	return FileAccess.file_exists(get_file_name(slot))


func is_area_discovered(scene_uid: String) -> bool:
	return discovered_areas.has(scene_uid)


func on_scene_entered(scene_uid: String) -> void:
	if discovered_areas.has(scene_uid) or pending_discovered_areas.has(scene_uid):
		return
	else:
		pending_discovered_areas.append(scene_uid)
	pass


#region /// config
func save_config() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "music", AudioServer.get_bus_volume_linear(2))
	config.set_value("audio", "sfx", AudioServer.get_bus_volume_linear(3))
	config.set_value("audio", "ui", AudioServer.get_bus_volume_linear(4))
	config.save(CONFIG_FILE_PATH)
	pass

func load_config() -> void:
	var config := ConfigFile.new()
	var err = config.load(CONFIG_FILE_PATH)
	if err != OK:
		AudioServer.set_bus_volume_linear(2, 0.7)
		AudioServer.set_bus_volume_linear(3, 1.0)
		AudioServer.set_bus_volume_linear(4, 1.0)
		save_config()
		return
	
	AudioServer.set_bus_volume_linear(2, config.get_value("audio", "music", 0.8))
	AudioServer.set_bus_volume_linear(3, config.get_value("audio", "sfx", 1.0))
	AudioServer.set_bus_volume_linear(4, config.get_value("audio", "ui", 1.0))
	pass

#endregion
