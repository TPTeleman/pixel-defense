extends Node
class_name PlantShooterNode

@export_group("Modules")
@export var plant: Plant
@export var nuzzle: Marker2D

@export var projectile: PackedScene

@export_group("Stats")
@export var damage: int = 20
@export var pierce: int = 1
@export var infinite_pierce: bool = false
@export var projectile_range: float = 0.0
@export var range_limit: bool = true
@export var projectile_amount: int = 1
@export var projectile_delay: float = 0.0

@onready var lawn: Lawn = plant.lawn



func shoot() -> Array[StraightPlantProjectile]:
	var projectiles: Array[StraightPlantProjectile]
	for i in projectile_amount:
		var proj := create_projectile()
		projectiles.append(proj)
		lawn.objects.add_child(proj)
		await get_tree().create_timer(projectile_delay).timeout
	return projectiles


func create_projectile() -> StraightPlantProjectile:
	var new_projectile: StraightPlantProjectile = projectile.instantiate()
	new_projectile.lane = plant.lane
	new_projectile.damage = damage
	new_projectile.pierce_amount = pierce
	new_projectile.infinite_pierce = infinite_pierce
	new_projectile.projectile_range = projectile_range
	new_projectile.range_limit = range_limit
	if nuzzle:
		new_projectile.global_position = nuzzle.global_position
	else:
		new_projectile.global_position = plant.global_position
	return new_projectile
