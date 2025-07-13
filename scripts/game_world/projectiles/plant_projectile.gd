extends Node2D
class_name PlantProjectile

signal hit_zombie(zombie: Zombie)

var damage: int
var velocity: Vector2
var lane : int
var starting_pos: Vector2
@export_enum("normal","fire","ice","water","electric") var damage_type: String
@export_enum("pea","sun") var sub_type: String


func _ready() -> void:
	starting_pos = global_position


func on_hit_zombie(zombie: Zombie) -> void:
	hit_zombie.emit(zombie)
	zombie.apply_damage(DamageRef.new(damage, damage_type, sub_type))
