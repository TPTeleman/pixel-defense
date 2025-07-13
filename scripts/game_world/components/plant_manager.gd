extends Node
class_name PlantManager

@onready var lawn: Lawn = get_node("../..")
@onready var grid: GridLawn = lawn.grid
@onready var entity_factory: EntityFactory = lawn.entity_factory



func _ready() -> void:
	pass


func create_plant_preview() -> void:
	var packet := lawn.selected_seed
	var mouse := lawn.mouse_pos
	var cell := lawn.hover_cell
	var cell_pos := lawn.cell_pos
	
	var mouse_plant = entity_factory.create_plant(packet, mouse, cell)
	var preview_plant = entity_factory.create_plant(packet, cell_pos, cell)
	
	lawn.objects.add_child(mouse_plant)
	lawn.objects.add_child(preview_plant)
	
	mouse_plant.z_index = 1
	preview_plant.modulate.a = 0.6
	
	lawn.mouse_plant = mouse_plant
	lawn.preview_plant = preview_plant


func try_place_selected() -> bool:
	var packet := lawn.selected_seed
	var cell := lawn.hover_cell
	if !packet or !cell_can_plant(packet, cell):
		return false
	lawn.sun_factory.spend_sun(packet.sun_cost)
	place_plant(packet, cell)
	return true


func try_remove_at_mouse() -> void:
	var cell := lawn.hover_cell
	var cell_plants := grid.get_plants_in_cell(cell)
	if !cell_plants.is_empty():
		var hover_plant: Plant = cell_plants[0]
		remove_plant(hover_plant)


func cell_can_plant(_packet: SeedPacket, cell: Vector2i) -> bool:
	if !grid.has_cell(cell):
		#print("Grid doesn't contain cell.")
		return false
	if !grid.grid[cell].plants.is_empty():
		#print("Cell already has a plant there.")
		return false
	return true


func place_plant(packet: SeedPacket, cell: Vector2i) -> void:
	var pos = grid.cell_to_pos(cell)
	var plant := entity_factory.create_plant(packet, pos, cell)
	plant.lawn = lawn
	lawn.plants.add_child(plant)
	
	plant.entity_died.connect(_on_plant_died)
	grid.add_plant_to_cell(plant, cell)
	lawn.plants_per_lane[plant.lane].append(plant)
	
	plant.on_plant()


func remove_plant(p: Plant) -> void:
	grid.remove_plant_from_cell(p, p.cell)
	lawn.plants_per_lane[p.lane].erase(p)
	p.call_deferred("queue_free")


func _on_plant_died(p: Plant) -> void:
	remove_plant(p)
