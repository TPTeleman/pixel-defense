extends Entity
class_name Plant

var is_planted: bool = false



func _ready() -> void:
	super._ready()
	hitbox.get_node("Collision_Shape").set_deferred("disabled", !is_planted)


func on_plant() -> void:
	is_planted = true
	hitbox.get_node("Collision_Shape").set_deferred("disabled", !is_planted)
	sprite.play_animation("idle")


func _process(_delta):
	pass


func on_animation_finished(_anim_name):
	pass
