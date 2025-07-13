extends Node
class_name PlantLobberComponent

@export_group("Modules")
@export var plant: Plant
@export var nuzzle: Marker2D

@export var projectile: PackedScene

@export_group("Stats")
@export var damage: int = 20
@export var height: int = 1
@export var duration: float = 0.65
@export var projectile_amount: int = 1
@export var projectile_delay: float = 0.0

@onready var lawn: Lawn = plant.lawn



func shoot() -> Array[LobbedPlantProjectile]:
	var projectiles: Array[LobbedPlantProjectile]
	for i in projectile_amount:
		var proj := create_projectile()
		projectiles.append(proj)
		lawn.objects.add_child(proj)
		await get_tree().create_timer(projectile_delay).timeout
	return projectiles


func create_projectile() -> LobbedPlantProjectile:
	var new_projectile: LobbedPlantProjectile = projectile.instantiate()
	new_projectile.lane = plant.lane
	new_projectile.damage = damage
	new_projectile.height = height
	new_projectile.duration = duration
	if nuzzle:
		new_projectile.global_position = nuzzle.global_position
	else:
		new_projectile.global_position = plant.global_position
	return new_projectile
