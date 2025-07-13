extends Plant

var current_state: int = 0


func on_plant() -> void:
	super.on_plant()
	sprite.play_animation("idle0")


func _on_damaged(amount: int) -> void:
	super._on_damaged(amount)
	if health_node.current_health > health_node.maximum_health * 0.66:
		current_state = 0
	elif health_node.current_health > health_node.maximum_health * 0.33:
		current_state = 1
	else:
		current_state = 2
	if sprite.get_animation() != "idle"+str(current_state):
		sprite.play_animation("idle"+str(current_state))
