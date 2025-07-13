extends Node
class_name ArmorComponent

signal broke

var maximum_armor: int = 0
var current_armor: int = 0
var is_broken: bool = true



func init(armor: int) -> void:
	maximum_armor = armor
	current_armor = armor
	is_broken = false


func increase_armor(value: int) -> void:
	current_armor += value
	current_armor = min(maximum_armor, current_armor)


func decrease_armor(value: int) -> int:
	var amount := value - current_armor
	current_armor -= value
	current_armor = max(0, current_armor)
	
	if current_armor <= 0 and !is_broken:
		is_broken = true
		broke.emit()
	return amount
