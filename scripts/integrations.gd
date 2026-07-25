extends TileMapLayer

@export var player: Player


func _check_tile_map_events() -> void:
	var player_grid_pos: Vector2i = local_to_map(player.global_position)
	var tile_data: TileData = get_cell_tile_data(player_grid_pos)

	if !tile_data:
		return

	if tile_data.get_custom_data("is_spike") == true:
		SignalBus.player_receive_dmg.emit()

	if tile_data.get_custom_data("is_exit") == true:
		SignalBus.level_completed.emit()


func _process(_delta: float) -> void:
	_check_tile_map_events()
