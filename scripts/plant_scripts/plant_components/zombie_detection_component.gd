extends Node
class_name ZombieDetectNode

@export var plant: Plant
@export var detect_range: float = 0.0

@onready var lawn: Lawn = plant.lawn



func get_zombies_in_range(exclude_group: String = "", lanes: Array[int] = []) -> Array[Zombie]:
	var zombies: Array[Zombie] = []
	
	if lanes.is_empty():
		lanes.append(plant.lane)
	
	for lane in lanes:
		for zombie in lawn.get_zombies_in_lane(lane):
			if exclude_group != "" and zombie.is_in_group(exclude_group):
				continue
			
			var dist = zombie.global_position.x - plant.global_position.x
			if dist < 0:
				continue
			if dist <= detect_range:
				zombies.append(zombie)
	return zombies


func get_closest_zombie(exclude_group: String = "", lanes: Array[int] = []) -> Zombie:
	var zombies: Array[Zombie] = get_zombies_in_range(exclude_group, lanes)
	var zombie: Zombie = null
	
	for z in zombies:
		if zombie == null:
			zombie = z
		else:
			var current_dist = zombie.global_position.x - plant.global_position.x
			var new_dist = z.global_position.x - plant.global_position.x
			if new_dist >= 0 and new_dist < current_dist:
				zombie = z
	return zombie


func get_each_zombie_lane(exclude_group: String = "", lanes: Array[int] = []) -> Array[Zombie]:
	var zombies: Array[Zombie] = []
	
	if lanes.is_empty():
		lanes.append(plant.lane)
	
	for lane in lanes:
		var closest: Zombie = null
		
		for zombie in lawn.get_zombies_in_lane(lane):
			if exclude_group != "" and zombie.is_in_group(exclude_group):
				continue
			
			var dist = zombie.global_position.x - plant.global_position.x
			if dist < 0 or dist > detect_range:
				continue
			
			if closest == null:
				closest = zombie
			else:
				var current_dist = abs(closest.global_position.x - plant.global_position.x)
				var new_dist = abs(zombie.global_position.x - plant.global_position.x)
				if new_dist < current_dist:
					closest = zombie
		
		zombies.append(closest)
	return zombies


func has_zombie_in_range(exclude_group: String = "", lanes: Array[int] = []) -> bool:
	if lanes.is_empty():
		lanes.append(plant.lane)
	
	for lane in lanes:
		for zombie in lawn.get_zombies_in_lane(lane):
			if exclude_group != "" and zombie.is_in_group(exclude_group):
				continue
			
			var dist = zombie.global_position.x - plant.global_position.x
			if dist < 0:
				continue
			if dist <= detect_range:
				return true
	return false
