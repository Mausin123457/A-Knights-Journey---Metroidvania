extends Area2D

const FIRE_CRACKLING_AUDIO = preload("uid://b1ygnnom4hlff")
@onready var area_2d: Area2D = $"."
var fire_player: AudioStreamPlayer2D
var tracked_body: Node2D
var fade_distance: float = 1.0

func _ready() -> void:
	fade_distance = _get_fade_distance()
	area_2d.body_entered.connect(_on_player_entered)
	area_2d.body_exited.connect(_on_player_exited)


func _process(_delta: float) -> void:
	if not (fire_player and is_instance_valid(fire_player)):
		return
	if not (tracked_body and is_instance_valid(tracked_body)):
		return

	var distance := tracked_body.global_position.distance_to(global_position)
	var t := clampf(distance / fade_distance, 0.0, 1.0)
	var eased_t := t * t
	fire_player.volume_linear = lerpf(1.0, 0.30, eased_t)


func _on_player_entered(_n: Node2D) -> void:
	tracked_body = _n
	if fire_player and is_instance_valid(fire_player):
		return
	fire_player = AudioStreamPlayer2D.new()
	add_child(fire_player)
	fire_player.bus = "SFX"
	fire_player.global_position = global_position
	fire_player.stream = FIRE_CRACKLING_AUDIO
	fire_player.play()
	pass

func _on_player_exited(_n: Node2D) -> void:
	if tracked_body == _n:
		tracked_body = null
	if fire_player and is_instance_valid(fire_player):
		Audio.fade_sfx_out(fire_player)
		fire_player = null
	pass


func _get_fade_distance() -> float:
	for c in get_children():
		if c is CollisionShape2D and c.shape:
			if c.shape is CircleShape2D:
				return max(c.shape.radius * maxf(absf(c.global_scale.x), absf(c.global_scale.y)), 1.0)
			if c.shape is RectangleShape2D:
				var extents: Vector2 = c.shape.size * 0.5
				return max(maxf(extents.x * absf(c.global_scale.x), extents.y * absf(c.global_scale.y)), 1.0)
	return 256.0
