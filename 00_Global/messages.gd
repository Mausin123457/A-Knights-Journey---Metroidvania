extends Node


@warning_ignore("unused_signal")
signal player_interacted(player: Player)

@warning_ignore("unused_signal")
signal player_healed(amount: int)

@warning_ignore("unused_signal")
signal player_health_changed(hp: int, max_hp: int)

@warning_ignore("unused_signal")
signal input_hint_changed(hint: String)
