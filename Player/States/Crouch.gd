class_name PlayerStateCrouch extends PlayerState

@export var decelaration_rate : float = 10.0


# What happens when this state is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play("Crouch")
	pass


# What happens when we leave this state?
func exit() -> void:
	pass


# What happens when an input comes in as were in this state?
func handle_input( event : InputEvent ) -> PlayerState:
	if event.is_action_pressed("jump"):
		if player.one_way_platform_shape_cast.is_colliding():
			player.position.y += 20
			return fall
		return jump
	return next_state


# What happens each process tick in this state?
func process( _delta : float ) -> PlayerState:
	if player.direction.y <= 0.5:
		return idle
	return next_state


#What happens each physics_process tick in this state?
func physics_process( delta : float ) -> PlayerState:
	player.velocity.x -= player.velocity.x * decelaration_rate * delta
	if player.is_on_floor() == false:
		return fall
	return next_state
