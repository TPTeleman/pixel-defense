extends Node
class_name HealthNode

signal died
signal damaged(amount: int)

var maximum_health : int = 0
var current_health : int = 0
var is_alive := false



func init(health: int) -> void:
	maximum_health = health
	current_health = health
	is_alive = true


func increase_health(value: int) -> void:
	current_health += value
	current_health = min(maximum_health, current_health)


func decrease_health(value: int) -> void:
	current_health -= value
	current_health = max(0, current_health)
	
	if is_alive:
		damaged.emit(value)
	if current_health <= 0 and is_alive:
		is_alive = false
		died.emit()
