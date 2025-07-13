extends CanvasLayer
class_name HUD

var all_windows: Dictionary = {}
var window_stack: Array[WindowControl]



func _ready() -> void:
	for child in get_children():
		if child is WindowControl:
			all_windows[child.name.trim_suffix("_Window").to_lower()] = child
	close_all_windows()
	open_window("Menu")


func open_window(window_name: String, context: Dictionary = {}) -> void:
	var window: WindowControl = all_windows.get(window_name.to_lower(), null)
	if !window:
		return
	
	if window_stack.size() > 0 and window_stack[-1] == window:
		close_current_window()
		return
	
	if window_stack.size() > 0:
		window_stack[-1].pause()
	
	window_stack.append(window)
	window.open(context)


func close_current_window() -> void:
	if window_stack.size() == 0:
		return
	
	var window: WindowControl = window_stack.pop_back()
	window.close()
	
	if window_stack.size() > 0:
		window_stack[-1].resume()


func close_all_windows() -> void:
	while window_stack.size() > 0:
		window_stack.pop_back().close()
