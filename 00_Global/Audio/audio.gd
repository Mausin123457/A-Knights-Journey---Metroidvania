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

#region /// Music tracks
func play_music(audio: AudioStream) -> void:
	var current_player: AudioStreamPlayer = get_music_player(current_track)
	if current_player.stream == audio:
		return
	
	var next_track: int = wrapi(current_track + 1, 0, 2)
	var next_player: AudioStreamPlayer = get_music_player(next_track)
	
	next_player.stream = audio
	next_player.play()
	
	for t in music_tweens:
		t.kill()
	music_tweens.clear()
	fade_track_out(current_player)
	fade_track_in(next_player)
	
	current_track = next_track
	pass


func get_music_player(i: int) -> AudioStreamPlayer:
	if i == 0:
		return music_1
	else:
		return music_2


func fade_track_out(player: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 0.0, 1.0)
	tween.tween_callback(player.stop)
	pass

func fade_sfx_out(player: AudioStreamPlayer2D) -> void:
	var tween: Tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 0.0, 3.0)
	tween.tween_callback(player.stop)
	tween.tween_callback(player.queue_free)
	pass

func fade_track_in(player: AudioStreamPlayer) -> void:
	var tween: Tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 1.0, 10.0)
	pass
#endregion

#region /// Reverb setting
func set_reverb(type: REVERB_TYPE) -> void:
	var reverb_sfx: AudioEffectReverb = AudioServer.get_bus_effect(1, 0)
	if not reverb_sfx:
		return
	AudioServer.set_bus_effect_enabled(1, 0, true)
	match type:
		REVERB_TYPE.NONE:
			AudioServer.set_bus_effect_enabled(1, 0, false)
		REVERB_TYPE.SMALL:
			reverb_sfx.room_size = 0.2
		REVERB_TYPE.MEDIUM:
			reverb_sfx.room_size = 0.5
		REVERB_TYPE.LARGE:
			reverb_sfx.room_size = 0.8
	pass
#endregion


#region /// 2D spatial sound
func play_spatial_sound(audio: AudioStream, pos: Vector2) -> void:
	var ap: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	add_child(ap)
	ap.bus = "SFX"
	ap.global_position = pos
	ap.stream = audio
	ap.finished.connect(ap.queue_free)
	ap.play()
	pass

#endregion


#region /// UI_audio
func play_ui_audio(audio: AudioStream) -> void:
	if ui_audio_player:
		ui_audio_player.play_stream(audio)
	pass


func setup_button_audio(node: Node) -> void:
	for c in node.find_children("*", "Button"):
		c.pressed.connect(play_ui_select_audio)
		c.focus_entered.connect(ui_focus_changed)
	pass


#region /// Ui_audio_getters
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
#endregion
