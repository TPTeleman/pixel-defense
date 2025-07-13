extends Node
class_name StatusManager

@export_group("Modules")
@export var entity: Entity

var active_effects: Array[StatusEffect]
var color_changes: Array[Color]

@onready var lawn: Lawn = entity.lawn



func _process(delta: float) -> void:
	if !active_effects.is_empty():
		for status in active_effects:
			status.current_duration -= delta
			
			if status.current_duration <= 0:
				on_status_expired(status.name, status.type)
				remove_status(status.name, status.type)


func apply_status(status_name: String, type: String, duration: float, context: Dictionary = {}) -> void:
	var status: StatusEffect = get_status(status_name, type)
	if status != null:
		if duration > status.current_duration:
			status.current_duration = duration
		if context.has("stacks"):
			status.current_stacks += context.get("stacks", 0)
			status.current_stacks = min(status.current_stacks, status.max_stacks)
	else:
		status = StatusEffect.new(status_name, type, duration)
		status.value = context.get("value", 0)
		status.max_stacks = context.get("max_stacks", 0)
		status.current_stacks = context.get("stacks", 0)
		active_effects.append(status)
		on_status_applied(status_name, type)


func remove_status(status_name: String, type: String, context: Dictionary = {}) -> void:
	var status: StatusEffect = get_status(status_name, type)
	if status != null:
		if !context.has("stacks"):
			active_effects.erase(status)
		else:
			status.current_stacks -= context.get("stacks", 0)
			status.current_stacks = max(status.current_stacks, 0)


func remove_statuses_by_type(type: String) -> void:
	var effects_to_remove: Array[StatusEffect]
	for status in active_effects:
		if status.type == type:
			on_status_expired(status.name, status.type)
			effects_to_remove.append(status)
	for status in effects_to_remove:
		print(status.name)
		active_effects.erase(status)


func on_status_applied(status_name: String, type: String) -> void:
	match status_name:
		"attack_slow","movement_slow","stunned":
			if type == "ice":
				color_changes.append(Color("78b7ff"))
	if is_instance_valid(entity.sprite):
		entity.sprite.modulate = Color("ffffff") if color_changes.is_empty() else color_changes[0]


func on_status_expired(status_name: String, type: String) -> void:
	match status_name:
		"attack_slow","movement_slow","stunned":
			if type == "ice":
				color_changes.erase(Color("78b7ff"))
	if is_instance_valid(entity.sprite):
		entity.sprite.modulate = Color("ffffff") if color_changes.is_empty() else color_changes[0]


func get_status(status_name: String, type: String) -> StatusEffect:
	for status in active_effects:
		if status.name == status_name and status.type == type:
			return status
	return null


func has_status(status_name: String, type: String) -> bool:
	for status in active_effects:
		if status.name == status_name and (type == "" or status.type == type):
			return true
	return false


func get_total_value(status_name: String) -> float:
	var value: float = 0
	for status in active_effects:
		if status.name == status_name :
			value += status.value
	return value


func get_total_stacks(status_name: String) -> int:
	var stacks: int = 0
	for status in active_effects:
		if status.name == status_name:
			stacks += status.current_stacks
	return stacks
