#class_name PlayerHud
extends CanvasLayer


@onready var animated_sprite_2d: AnimatedSprite2D = $Control/AnimatedSprite2D

func _ready() -> void:
	Messages.player_health_changed.connect(update_healthbar)
	pass



@warning_ignore("unused_parameter")
func update_healthbar(hp: int, max_hp: int) -> void:
	animated_sprite_2d.frame = hp
	pass
