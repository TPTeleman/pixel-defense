extends Control
class_name WindowControl

var is_open: bool = false
var is_paused: bool = false


func open(context: Dictionary = {}) -> void:
	show()
	is_open = true
	is_paused = false
	_on_open(context)


func _on_open(context: Dictionary) -> void:
	pass


func close() -> void:
	hide()
	is_open = false
	_on_close()


func _on_close() -> void:
	pass


func resume() -> void:
	is_paused = false


func pause() -> void:
	is_paused = true
