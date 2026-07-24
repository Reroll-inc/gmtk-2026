extends TileMapLayer

@export var player: Player


func _check_tile_map_events() -> void:
	var player_grid_pos: Vector2i = local_to_map(player.global_position)
	var tile_data: TileData = get_cell_tile_data(player_grid_pos)

	if tile_data and tile_data.get_custom_data("is_spike") == true:
		print("Player stepped on a spike!")


func _physics_process(_delta: float) -> void:
	_check_tile_map_events()
