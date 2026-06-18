@icon( "res://Player/States/state.svg" )
class_name PlayerState extends Node

var player : Player
var next_state : PlayerState

#region /// State references
# reference to all other states
@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var fall: PlayerStateFall = %Fall
@onready var jump: PlayerStateJump = %Jump
@onready var crouch: PlayerStateCrouch = %Crouch

#endregion

# What happens when this state is initialized?
func init() -> void:
	pass

# What happens when we enter this state?
func enter() -> void:
	pass


# What happens when we leave this state?
func exit() -> void:
	pass

# What happens when an input comes in as were in this state?
func handle_input( _event : InputEvent ) -> PlayerState:
	return next_state

# What happens each process tick in this state?
func process( _delta : float ) -> PlayerState:
	return next_state

#What happens each physics_process tick in this state?
func physics_process( _delta : float ) -> PlayerState:
	return next_state
