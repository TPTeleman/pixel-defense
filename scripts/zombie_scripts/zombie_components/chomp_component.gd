extends Node
class_name ChompNode

@export var damage: int = 50



func chomp_plant(plant: Plant) -> void:
	plant.apply_damage(DamageRef.new(damage, "", ""))
