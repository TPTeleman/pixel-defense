extends StraightPlantProjectile

@export var slow_duration: float = 2.0
@export var slow_power: float = 0.5


func on_hit_zombie(zombie: Zombie) -> void:
	super.on_hit_zombie(zombie)
	if !zombie.is_in_group("Object"):
		zombie.remove_statuses_by_type("fire")
		zombie.apply_status("attack_slow","ice",slow_duration,{"value": slow_power})
		zombie.apply_status("movement_slow","ice",slow_duration,{"value": slow_power})
