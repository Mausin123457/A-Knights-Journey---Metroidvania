class_name PauseMenu extends CanvasLayer

#region /// On ready variables
@onready var system: Control = $Control/System
@onready var pause_screen: Control = $Control/PauseScreen
@onready var menu_button: Button = %MenuButton
@onready var return_button: Button = %ReturnButton
@onready var quit_to_title_button: Button = %QuitToTitleButton
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
@onready var pause_menu: PauseMenu = $"."
@onready var map: Control = $Control/PauseScreen/Map
@onready var map_button: Button = %MapButton
@onready var abilities_button: Button = %AbilitiesButton
@onready var abilities: Control = $Control/PauseScreen/Abilities

#endregion

var player: Player 
var player_position : Vector2
func _ready() -> void:
	if pause_menu.visible == true:
		PlayerHud.visible = false
	setup_system_menu()
	show_pause_screen()
	return_button.pressed.connect(show_pause_screen)
	quit_to_title_button.pressed.connect(quit_to_title)
	menu_button.pressed.connect(show_system_menu)
	map_button.pressed.connect(show_pause_screen)
	abilities_button.pressed.connect(show_abilities)
	Audio.setup_button_audio(self)
	var player2: Node2D = get_tree().get_first_node_in_group("player")
	if player2: 
		player_position = player.global_position
	pass


func setup_system_menu() -> void:
	music_slider.value = AudioServer.get_bus_volume_linear(2)
	sfx_slider.value = AudioServer.get_bus_volume_linear(3)
	ui_slider.value = AudioServer.get_bus_volume_linear(4)
	
	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	ui_slider.value_changed.connect(_on_ui_slider_changed)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel") and system.visible != true:
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		PlayerHud.visible = true
		queue_free()
	elif event.is_action_pressed("ui_cancel") and system.visible == true:
		show_pause_screen()
	
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		Messages.controller_changed.emit(event.device)
	
	if event is InputEventMouseButton or event is InputEventKey:
		Messages.controller_changed.emit(event.device)
	pass


func show_pause_screen() -> void:
	pause_screen.visible = true
	system.visible = false
	map.visible = true
	abilities.visible = false
	map_button.grab_focus()
	pass


func show_system_menu() -> void:
	pause_screen.visible = false
	system.visible = true
	return_button.grab_focus()
	pass

func show_abilities() -> void:
	pause_screen.visible = true
	system.visible = false
	map.visible = false
	abilities.visible = true
	pass

func quit_to_title() -> void:
	get_tree().paused = false
	Messages.back_to_title.emit()
	queue_free()
	SceneManager.transition_scene("res://title_screen/Title_screen.tscn", "", Vector2.ZERO, "up")
	pass


func _on_music_slider_changed(v: float) -> void:
	AudioServer.set_bus_volume_linear(2, v)
	SaveManager.save_config()
	pass

func _on_sfx_slider_changed(v: float) -> void:
	AudioServer.set_bus_volume_linear(3, v)
	Audio.play_spatial_sound(Audio.ui_focus_audio, player_position)
	SaveManager.save_config()
	pass 

func _on_ui_slider_changed(v: float) -> void:
	AudioServer.set_bus_volume_linear(4, v)
	Audio.ui_focus_changed()
	SaveManager.save_config() 
	pass
