extends Node
class_name PlantDetectionComponent

const pre_dectection: float = 16.0

@export var zombie: Zombie
@export var detect_range: float = 0.0

@onready var lawn: Lawn = zombie.lawn



func get_plants_in_range() -> Array[Plant]:
	var plants: Array[Plant] = []
	for plant in lawn.get_plants_in_lane(zombie.lane):
		var dist = (zombie.global_position.x + pre_dectection) - plant.global_position.x
		if dist < 0:
			continue
		if dist <= (detect_range + pre_dectection):
			plants.append(plant)
	return plants


func get_closest_plant() -> Plant:
	var plants: Array[Plant] = get_plants_in_range()
	var plant: Plant = null
	for p in plants:
		if plant == null:
			plant = p
		else:
			var current_dist = (zombie.global_position.x + pre_dectection) - plant.global_position.x
			var new_dist = (zombie.global_position.x + pre_dectection) - p.global_position.x
			if new_dist >= 0 and new_dist < current_dist:
				plant = p
	return plant


func has_plant_in_range() -> bool:
	for plant in lawn.get_plants_in_lane(zombie.lane):
		var dist = (zombie.global_position.x + pre_dectection) - plant.global_position.x
		if dist < 0:
			continue
		if dist <= (detect_range + pre_dectection):
			return true
	return false
