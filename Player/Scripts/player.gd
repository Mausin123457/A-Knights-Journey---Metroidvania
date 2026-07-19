class_name Player
extends CharacterBody2D

const JUMP_DEBUG = preload("uid://cpvmgqgx6yfja")

#region /// export variables
@export var move_speed : float = 100
@export var max_fall_velocity : float = 500
@export var break_delay: float = 0.8
@export var respawn_delay: float = 3.0
@export var shake_intensity: float = 2.0
#endregion

#region /// Onready variables
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var one_way_platform_shape_cast: ShapeCast2D = %OneWayPlatformShapeCast
@onready var break_timer = %BreakTimer
@onready var respawn_timer = %RespawnBreakTimer
@onready var player: Player = %Player
#endregion

#region /// State Machine variables
var states : Array[ PlayerState ]
var current_state : PlayerState:
	get: return states.front()
var previous_state : PlayerState:
	get: return states[1]
#endregion


#region /// Stats
var hp: int = 5:
	set(value):
		hp = clampi(value, 0, 5)
		Messages.player_health_changed.emit(hp, max_hp)

var max_hp: int = 5:
	set(value):
		max_hp = clampi(value, 0, 5)
		Messages.player_health_changed.emit(hp, max_hp)

var dash: bool = false
var wall_jump: bool = false
var parry: bool = false
#endregion


#region /// Standard variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var gravity_multiplier : float = 1.0
var is_shaking: bool = false
var original_sprite_pos: Vector2
#endregion


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		Messages.player_interacted.emit(self, event)
		Messages.input_hint_changed.emit("interact")
	elif event.is_action_pressed("pause"):
		get_tree().paused = true
		var pause_menu: PauseMenu = load("res://pause_menu/Pause_menu.tscn").instantiate()
		add_child(pause_menu)
		return
	
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_MINUS:
			hp -= 1
			print(hp)
		elif event.keycode == KEY_EQUAL:
			hp += 1
			print(hp)
	
	change_state(current_state.handle_input(event))
	pass


func _ready() -> void:
	if get_tree().get_first_node_in_group("Player") != self:
		self.queue_free()
	
	initialize_states()
	self.call_deferred("reparent", get_tree().root)
	PlayerHud.visible = true
	Messages.player_healed.connect(on_player_healed)
	Messages.back_to_title.connect(queue_free)
	pass


func _process(_delta: float) -> void:
	update_direction()
	change_state(current_state.process(_delta))


func _physics_process(_delta: float) -> void:
	if SceneManager.allow_input == false:
		return
	else:
		velocity.y += gravity * _delta * gravity_multiplier
		velocity.y = clampf(velocity.y, -1000, max_fall_velocity)
		move_and_slide()
		change_state(current_state.physics_process(_delta))

		if is_on_floor():
			var info = get_breakable_tile_below()
			if info:
				info["tilemap"].break_tile(info["cell"])



func initialize_states() -> void:
	states = []

	for i in $States.get_children():
		if i is PlayerState:
			states.append(i)
			i.player = self

	if states.size() == 0:
		return

	for state in states:
		state.init()

	change_state(current_state)
	current_state.enter()


func change_state(new_state : PlayerState) -> void:
	if new_state == null:
		return
	if new_state == current_state:
		return

	if current_state:
		current_state.exit()

	states.push_front(new_state)
	current_state.enter()
	states.resize(3)


func update_direction() -> void:
	var prev_direction : Vector2 = direction

	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)

	if prev_direction.x != direction.x:
		if direction.x < 0 and current_state.name != "Crouch":
			sprite.flip_h = true
		if direction.x > 0 and current_state.name != "Crouch":
			sprite.flip_h = false



func add_debug_indicator(color : Color = Color.RED) -> void:
	var d : Node2D = JUMP_DEBUG.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer(3.0).timeout
	d.queue_free()


func get_breakable_tile_below() -> Dictionary:
	@warning_ignore("integer_division")
	var foot_pos = global_position + Vector2(0, 42 / 2 + 1)

	for tilemap in get_tree().get_nodes_in_group("breakable_tilemaps"):
		var local = tilemap.to_local(foot_pos)
		var _cell = tilemap.local_to_map(local)


	for tilemap in get_tree().get_nodes_in_group("breakable_tilemaps"):
		if not tilemap is BreakableTileMap:
			continue
			
		var _local = tilemap.to_local(foot_pos)
		var cell = tilemap.local_to_map(tilemap.to_local(foot_pos))

		if tilemap.get_cell_source_id(cell) != -1:
			return {"tilemap": tilemap, "cell": cell}

	return {}


func on_player_healed(amount: int) -> void:
	hp += amount
	print("healed: ", amount)
	pass
