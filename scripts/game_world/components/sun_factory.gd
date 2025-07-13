extends Node
class_name SunFactory

const SUN := preload("res://scenes/game_world/sun/sun_node.tscn")

var first_sun_delay: float = 0.0
var sun_delay: float = 0.0
var variation: float = 2.0

var sun_power: int = 0
var first_sun_needed: int = 0

var first_sun_count: int = 0
var first_sun: float = 0.0
var sun_time: float = 0.0

var can_produce: bool = false

@onready var lawn: Lawn = get_node("../..")



func set_up_timers(level: LevelData) -> void:
	first_sun_count = level.first_sun_needed
	first_sun_delay = level.first_sun_delay
	first_sun = first_sun_delay + randf_range(-variation, variation)
	first_sun_needed = level.first_sun_needed
	
	sun_delay = level.sun_delay
	sun_time = sun_delay + randf_range(-variation, variation)
	sun_power = level.sun_power


func _process(delta: float) -> void:
	if !can_produce:
		return
	if first_sun_count > 0:
		if first_sun > 0:
			first_sun -= delta
		else:
			first_sun = first_sun_delay + randf_range(-variation, variation)
			first_sun_count -= 1
			create_sun()
	else:
		if sun_time > 0:
			sun_time -= delta
		else:
			sun_time = sun_delay + randf_range(-variation, variation)
			create_sun()


func create_sun() -> void:
	spawn_sun(Vector2(randf_range(80, 312), 0), sun_power, 72)


func spawn_sun(pos: Vector2, sun_value: int = 25, fall_variant: int = 0) -> Sun:
	var new_sun: Sun = SUN.instantiate()
	new_sun.value = sun_value
	new_sun.position = pos
	new_sun.fall_range += randf_range(-fall_variant, fall_variant)
	
	if sun_value < 25:
		new_sun.scale = Vector2(0.2, 0.2)+Vector2(0.8*(float(sun_value)/25), 0.8*(float(sun_value)/25))
	elif sun_value > 25:
		new_sun.scale = Vector2(0.8, 0.8)+Vector2(0.2*(float(sun_value)/25), 0.2*(float(sun_value)/25))
	
	lawn.objects.add_child(new_sun)
	new_sun.sun_collected.connect(_on_sun_collected)
	
	return new_sun


func _on_sun_collected(sun: Sun) -> void:
	gain_sun(sun.value)
	sun.queue_free()


func set_sun(amount: int) -> void:
	lawn.sun_amount = amount
	lawn.gui.update_sun_amount(lawn.sun_amount)
	lawn.handle_seed_cost()


func spend_sun(amount: int) -> void:
	lawn.sun_amount -= amount
	lawn.gui.update_sun_amount(lawn.sun_amount)
	lawn.handle_seed_cost()


func gain_sun(amount: int) -> void:
	lawn.sun_amount += amount
	lawn.gui.update_sun_amount(lawn.sun_amount)
	lawn.handle_seed_cost()
