extends Node
class_name InputManager

@onready var lawn: Lawn = get_node("../..")
@onready var plant_manager: PlantManager = lawn.plant_manager



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == 1:
			if plant_manager.try_place_selected():
				lawn.selected_seed.enter_cooldown()
				deselect_seed()
		elif event.button_index == 2:
			if lawn.selected_seed != null:
				deselect_seed()
				return
			plant_manager.try_remove_at_mouse()


func _on_gui_plant_button_pressed(node_idx: int, seed_idx: int) -> void:
	var packet := lawn.seed_inventory[seed_idx]
	deselect_seed()
	select_seed(packet, node_idx)


func select_seed(packet: SeedPacket, node_index: int) -> void:
	if packet.sun_cost > lawn.sun_amount or packet.current_charge > 0.175:
		return
	lawn.selected_seed = packet
	lawn.selected_packet_node = node_index
	plant_manager.create_plant_preview()
	
	lawn.gui.set_packet_state(node_index, "selected", true)


func deselect_seed() -> void:
	lawn.gui.set_packet_state(lawn.selected_packet_node, "selected", false)
	
	lawn.selected_seed = null
	lawn.selected_packet_node = -1
	if is_instance_valid(lawn.mouse_plant):
		lawn.mouse_plant.queue_free()
		lawn.mouse_plant = null 
	if is_instance_valid(lawn.preview_plant):
		lawn.preview_plant.queue_free()
		lawn.preview_plant = null 
