extends Node
class_name ZombieMovement

@export var zombie: Zombie
@export var walk_speed: float = 10.0
@export var direction: Vector2 = Vector2(-1, 0)

var velocity: Vector2
var can_move: bool = false


func _physics_process(delta) -> void:
	velocity = direction * get_speed()
	if can_move:
		move(delta)


func get_speed() -> float:
	var final_speed: float = walk_speed
	if zombie.has_status("movement_slow"):
		final_speed *= 1 - zombie.get_total_value("movement_slow")
	if zombie.has_status("movement_haste"):
		final_speed *= 1 + zombie.get_total_value("movement_haste")
	return final_speed


func move(delta) -> void:
	zombie.position += velocity * delta
