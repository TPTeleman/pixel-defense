extends Node
class_name CooldownNode

signal timeout

@export var entity: Entity

@export var cooldown_type: String
@export var cooldown_time = 1.0
@export var variation := 0.0

var is_enabled: bool = false
var timer = 0.0
var timedout: bool = false



func _ready() -> void:
	reset()


func _process(delta):
	if is_enabled:
		if timer > 0:
			timer -= get_speed(delta)
		else:
			if !timedout:
				timedout = true
				timeout.emit()


func get_speed(speed: float) -> float:
	var final_speed: float = speed
	if entity.has_status(cooldown_type+"_slow"):
		final_speed *= 1 - entity.get_total_value(cooldown_type+"_slow")
	if entity.has_status(cooldown_type+"_haste"):
		final_speed *= 1 + entity.get_total_value(cooldown_type+"_haste")
	return final_speed


func is_ready():
	return timer <= 0


func reset():
	timedout = false
	timer = cooldown_time + randf_range(-variation, variation)
