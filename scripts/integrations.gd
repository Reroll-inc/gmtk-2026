extends TileMapLayer

signal on_die()

signal on_complete()

@export var player: Player


func _check_tile_map_events() -> void:
	var player_grid_pos: Vector2i = local_to_map(player.global_position)
	var tile_data: TileData = get_cell_tile_data(player_grid_pos)

	if !tile_data:
		return

	if tile_data.get_custom_data("is_spike") == true:
		print("Player stepped on a spike!")
		on_die.emit()

	if tile_data.get_custom_data("is_exit") == true:
		print("Player reached exit!")
		on_complete.emit()


func _process(_delta: float) -> void:
	_check_tile_map_events()
