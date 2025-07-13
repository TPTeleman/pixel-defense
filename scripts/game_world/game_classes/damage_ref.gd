extends RefCounted
class_name DamageRef

var value: int = 0
var type: String = ""
var subtype: String = ""
var source: Entity = null



func _init(_damage: int, _type: String, _subtype: String, _source: Entity = null) -> void:
	value = _damage
	type = _type
	subtype = _subtype
	source = _source
