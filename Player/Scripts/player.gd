class_name Player extends CharacterBody2D

const JUMP_DEBUG = preload("uid://cpvmgqgx6yfja")

#region /// export variables
@export var move_speed : float = 100
@export var max_fall_velocity : float = 500
#endregion

#region /// Onready variables
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var one_way_platform_shape_cast: ShapeCast2D = %OneWayPlatformShapeCast
#endregion


#region /// State Machine variables
var states : Array[ PlayerState ]
var current_state : PlayerState : 
	get : return states.front()
var previous_state : PlayerState :
	get : return states[1]
#endregion

#region /// Standard variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var gravity_multiplier : float = 1.0
#endregion




func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))
	pass

func _ready() -> void:
	#initialize states
	initialize_states()
	pass


func _process( _delta: float) -> void:
	update_direction()
	change_state(current_state.process(_delta))
	pass


func _physics_process( _delta: float) -> void:
	velocity.y += gravity * _delta * gravity_multiplier
	velocity.y = clampf(velocity.y, -1000, max_fall_velocity)
	move_and_slide()
	change_state(current_state.physics_process(_delta))
	
	pass


func initialize_states() -> void:
	states = []
	#gather all states
	for i in $States.get_children():
		if i is PlayerState:
			states.append(i)
			i.player = self
		pass
		
	if states.size() == 0:
		return

	#initialize states
	for state in states:
		state.init()

	#set our first state
	change_state(current_state)
	current_state.enter()
	$Label.text = current_state.name
	pass
	

func change_state( new_state : PlayerState ) -> void:
	if new_state == null:
		return
	elif new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front(new_state)
	current_state.enter()
	states.resize( 3 )
	$Label.text = current_state.name
	
	pass
	

func update_direction() -> void:
	var prev_direction : Vector2 = direction
	
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	
	if prev_direction.x != direction.x:
		if direction.x < 0 && current_state.name != "Crouch":
			sprite.flip_h = true
		if direction.x > 0 && current_state.name != "Crouch":
			sprite.flip_h = false
	
	pass
	

func add_debug_indicator( color : Color = Color.RED) -> void:
	var d : Node2D = JUMP_DEBUG.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer(3.0).timeout
	d.queue_free()
	pass
