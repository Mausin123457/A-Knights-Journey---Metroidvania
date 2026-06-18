class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 450.0

# What happens when this state is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play("Jump")
	player.animation_player.pause()
	#player.add_debug_indicator( Color.SEA_GREEN )
	player.velocity.y = -jump_velocity
	
	#Check if buffer jump
	if player.previous_state == fall && !Input.is_action_pressed("jump"):
		await get_tree().physics_frame
		player.velocity.y *= 0.5
		player.change_state(fall)
		pass
		
	pass


# What happens when we leave this state?
func exit() -> void:
	#player.add_debug_indicator(Color.YELLOW)
	pass


# What happens when an input comes in as were in this state?
func handle_input( event : InputEvent ) -> PlayerState:
	if event.is_action_released("jump"):
		player.velocity.y *= 0.3
		return fall
	return next_state


# What happens each process tick in this state?
func process( _delta : float ) -> PlayerState:
	set_jump_frame()
	return next_state


#What happens each physics_process tick in this state?
func physics_process( _delta : float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.move_speed
	return next_state
	

func set_jump_frame() -> void:
	var frame : float = remap(player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5)
	player.animation_player.seek(frame, true)
	pass
