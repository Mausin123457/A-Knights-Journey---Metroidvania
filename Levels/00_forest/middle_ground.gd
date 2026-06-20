extends TileMapLayer
class_name BreakableTileMap

@export var break_delay: float = 1.1
@export var respawn_delay: float = 3.0
@export var shake_intensity: float = 2.0

var breaking_tiles: Dictionary = {}

func _ready():
	add_to_group("breakable_tilemaps")
	fix_collision()

func fix_collision():
	# Forceer Godot om collision opnieuw te genereren
	var old = tile_set
	tile_set = null
	await get_tree().process_frame
	tile_set = old



func break_tile(cell: Vector2i) -> void:
	var source_id = get_cell_source_id(cell)
	if source_id == -1 or breaking_tiles.has(cell):
		return
		
	var atlas_coords = get_cell_atlas_coords(cell)
	var alternative_tile = get_cell_alternative_tile(cell)
	breaking_tiles[cell] = {
		"source_id": source_id,
		"atlas_coords": atlas_coords,
		"alternative_tile": alternative_tile
	}

	var tile_set_source: TileSetAtlasSource = tile_set.get_source(source_id)
	var tile_texture = tile_set_source.texture
	var texture_region = tile_set_source.get_tile_texture_region(atlas_coords)

	var dummy_sprite = Sprite2D.new()
	dummy_sprite.texture = tile_texture
	dummy_sprite.region_enabled = true
	dummy_sprite.region_rect = texture_region

	var tile_world_pos = map_to_local(cell) + global_position
	dummy_sprite.global_position = tile_world_pos
	get_tree().current_scene.add_child(dummy_sprite)

	var time_passed = 0.0
	while time_passed < break_delay:
		var random_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		dummy_sprite.global_position = tile_world_pos + random_offset
		await get_tree().physics_frame
		time_passed += get_process_delta_time()
	set_cell(cell, -1)

	dummy_sprite.queue_free()

	await get_tree().create_timer(respawn_delay).timeout

	var data = breaking_tiles[cell]
	set_cell(cell, data["source_id"], data["atlas_coords"], data["alternative_tile"])
	breaking_tiles.erase(cell)
