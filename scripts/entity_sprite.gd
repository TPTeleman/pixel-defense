extends Node2D
class_name EntitySprite

signal animation_finished(anim_name: StringName)

@onready var entity: Entity = get_parent()
@onready var anim = $Anim



func _ready() -> void:
	anim.animation_finished.connect(_on_anim_animation_finished)


func get_animation() -> String:
	return anim.current_animation


func set_anim_speed(speed: float) -> void:
	anim.speed_scale = speed


func play_animation(anim_name: String) -> void:
	if anim.has_animation(anim_name) and anim.current_animation != anim_name:
		anim.play(anim_name)


func call_owner(method: String, args: Array = []) -> void:
	if entity and entity.has_method(method):
		entity.callv(method, args)
	else:
		push_warning("Owner does not have method: %s" % method)


func _on_anim_animation_finished(anim_name: StringName) -> void:
	animation_finished.emit(anim_name)
