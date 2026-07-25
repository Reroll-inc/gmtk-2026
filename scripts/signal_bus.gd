extends Node

@warning_ignore("unused_signal")
signal player_receive_dmg()

@warning_ignore("unused_signal")
signal player_got_spike()

@warning_ignore("unused_signal")
signal enemy_killed(type: Enemy.Type)

@warning_ignore("unused_signal")
signal score_update(value: int)

@warning_ignore("unused_signal")
signal remove_mechanic(type: Mechanic.Type)

@warning_ignore("unused_signal")
signal level_completed()

@warning_ignore("unused_signal")
signal game_failed()
