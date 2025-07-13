extends Node
class_name EntityFactory

var plant_count := 0
var zombie_count := 0

@onready var lawn: Lawn = get_node("../..")



func create_plant(_seed: SeedPacket, pos: Vector2, cell: Vector2i) -> Plant:
	var plant: Plant = _seed.plant.instantiate()
	plant.name = "Plant_" + str(plant_count)
	plant.cell = cell
	plant.lane = cell.y
	plant.position = pos
	plant_count += 1
	return plant


func create_zombie(scene: PackedScene, pos: Vector2, cell: Vector2i) -> Zombie:
	var zombie: Zombie = scene.instantiate()
	zombie.name = "Zombie_" + str(zombie_count)
	zombie.cell = cell
	zombie.lane = cell.y
	zombie.position = pos
	zombie_count += 1
	return zombie
