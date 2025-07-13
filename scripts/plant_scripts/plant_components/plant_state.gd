extends Node
class_name PlantState

enum State { IDLE, PRE_ACTION, ACTION }

var plant : Plant
var state := State.IDLE



func init(_plant) -> void:
	plant = _plant


func tick(_delta) -> void:
	pass


func transition_to(new_state) -> void:
	state = new_state
