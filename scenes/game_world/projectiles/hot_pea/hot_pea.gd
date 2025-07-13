extends StraightPlantProjectile

var main_target: Zombie
var splash_damage: int

@onready var splashbox: Area2D = $Splashbox



func on_hit_zombie(zombie: Zombie) -> void:
	super.on_hit_zombie(zombie)
	main_target = zombie
	if !zombie.is_in_group("Object"):
		zombie.remove_statuses_by_type("ice")
	splash_onto_enemies()


func splash_onto_enemies() -> void:
	for area in splashbox.get_overlapping_areas():
		if area is Hitbox:
			var hitbox = area as Hitbox
			var body: Entity = hitbox.body
			if body is Zombie:
				var zombie: Zombie = hitbox.body
				if zombie != main_target and zombie.lane == lane:
					zombie.apply_damage(DamageRef.new(splash_damage, damage_type, sub_type))
					if !zombie.is_in_group("Object"):
						zombie.remove_statuses_by_type("ice")
