extends Zombie
class_name ObjectEntity



func _on_damaged(amount: int) -> void:
	entity_damaged.emit(self, amount)


func _on_died() -> void:
	entity_died.emit(self)
	call_deferred("queue_free")
