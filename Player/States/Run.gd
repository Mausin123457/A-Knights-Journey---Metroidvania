class_name PlayerStateRun extends PlayerState

# What happens when this state is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play("Run")
	pass


# What happens when we leave this state?
func exit() -> void:
	pass


# What happens when an input comes in as were in this state?
func handle_input( event : InputEvent ) -> PlayerState:
	if SceneManager.allow_input == false:
		return
	if event.is_action_pressed("jump"):
		return jump
	elif event.is_action_pressed("down") && player.one_way_platform_shape_cast.is_colliding():
		return crouch
	return next_state


# What happens each process tick in this state?
func process( _delta : float ) -> PlayerState:
	if player.direction.x == 0:
		return idle
	return next_state


#What happens each physics_process tick in this state?
func physics_process( _delta : float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor() == false:
		return fall
	return next_state
