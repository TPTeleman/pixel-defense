extends Node
class_name SunMakerNode

@export var plant: Plant
@export var sun_point: Node2D
@export_range(5, 25, 5, "or_greater") var sun_value: int = 25

@export_group("Movement")
@export var horizontal_speed: float = 900
@export var fall_speed: float = -190
@export var gravity_speed: float = 320
@export var fall_range: float = 32

var sun_factory: SunFactory



func create_sun():
	var sun: Sun = sun_factory.spawn_sun(sun_point.global_position, sun_value, 0)
	sun.horizontal_speed = randf_range(-horizontal_speed, horizontal_speed)
	sun.direction = [-1, 1].pick_random()
	sun.fall_speed = fall_speed
	sun.gravity_speed = gravity_speed
	sun.fall_range = fall_range+randf_range(-15, 15)
