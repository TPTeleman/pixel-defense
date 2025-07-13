extends Resource
class_name StatusEffect

var name: String
var type: String
var value: float
var max_duration: float
var current_duration: float
var max_stacks: int
var current_stacks: int



func _init(_name, _type, duration):
	name = _name
	type = _type
	max_duration = duration
	current_duration = duration
