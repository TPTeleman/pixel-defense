extends Node2D
class_name GridLawn

const TILES := {
	"grass": Vector2i(0, 0),
	"water": Vector2i(0, 1),
	"rock": Vector2i(0, 2),
}

@export var cell_size := Vector2i(26, 32)
@export var grid_size := Vector2i(10, 5)
@export var tile_slant := Vector2i(0, 4)

var grid: Dictionary = {}

@export_group("Tilemaps")
@export var default_map: TileMapLayer
@export var slanted_map: TileMapLayer



func create_grid() -> Dictionary:
	default_map.clear()
	slanted_map.clear()
	
	var variation: int = 0
	for y in grid_size.y:
		for x in grid_size.x:
			var index := Vector2i(x,y)
			grid[index] = {
				"position": Vector2i(),
				"soil": "grass",
				"plants": [] as Array[Plant],
				"slant": {"is_slanted": false, "elevation": 1, "slant_dir": 0}
			}
			
			var tile = grid[index]
			default_map.set_cell(pos_to_cell(position * 2) + index, 0, TILES[tile.soil] + Vector2i(variation, 0))
			
			variation = 1 if variation == 0 else 0
	return grid


func add_plant_to_cell(plant: Plant, cell: Vector2i) -> void:
	if grid.has(cell):
		grid[cell].plants.append(plant)


func remove_first_from_cell(cell: Vector2i) -> void:
	if grid.has(cell) and !grid[cell].plants.is_empty():
		grid[cell].plants.pop_front()


func remove_plant_from_cell(plant: Plant, cell: Vector2i) -> void:
	if grid.has(cell):
		grid[cell].plants.erase(plant)


func get_plants_in_cell(cell: Vector2i) -> Array[Plant]:
	if grid.has(cell):
		return grid[cell].plants
	return []


func cell_to_pos(cell: Vector2i) -> Vector2:
	var center_x: int = roundi(float(cell_size.x)/2)
	var center_y: int = roundi(float(cell_size.y)/2)
	return position + Vector2(cell.x*cell_size.x, cell.y*cell_size.y) + Vector2(center_x, center_y)


func pos_to_cell(pos: Vector2) -> Vector2i:
	var final_pos := pos - position
	return Vector2i(int(floor(final_pos.x/cell_size.x)), int(floor(final_pos.y/cell_size.y)))


func has_cell(cell: Vector2i) -> bool:
	return grid.has(cell)
