extends Node
#class_name Audio


enum REVERB_TYPE {NONE, SMALL, MEDIUM, LARGE}

@export var ui_focus_audio: AudioStream
@export var ui_select_audio: AudioStream
@export var ui_success_audio: AudioStream
@export var ui_cancel_audio: AudioStream
@export var ui_error_audio: AudioStream

var current_track: int = 0
var music_tweens: Array[Tween]
var ui_audio_player: AudioStreamPlaybackPolyphonic

@onready var music_1: AudioStreamPlayer = %Music1
@onready var music_2: AudioStreamPlayer = %Music2
@onready var ui: AudioStreamPlayer = %UI


func _ready() -> void:
	ui.play()
	ui_audio_player = ui.get_stream_playback()
	pass


func play_ui_audio(audio: AudioStream) -> void:
	if ui_audio_player:
		ui_audio_player.play_stream(audio)
	pass


func setup_button_audio(node: Node) -> void:
	for c in node.find_children("*", "Button"):
		c.pressed.connect(play_ui_select_audio)
		c.focus_entered.connect(ui_focus_changed)
	pass


#region /// audio getters
func ui_focus_changed() -> void:
	play_ui_audio(ui_focus_audio)
	pass

func play_ui_select_audio() -> void:
	play_ui_audio(ui_select_audio)
	pass

func play_ui_cancel_audio() -> void:
	play_ui_audio(ui_cancel_audio)
	pass

func play_ui_succes_audio() -> void:
	play_ui_audio(ui_success_audio)

func play_ui_error_audio() -> void:
	play_ui_audio(ui_error_audio)
	pass
#endregion
