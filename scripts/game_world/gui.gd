extends CanvasLayer
class_name GUI

signal plant_button_pressed(node_index: int, seed_index: int)

@onready var sun_label: Label = %Sun_Label
@onready var packet_grid: VBoxContainer = %Packet_Grid
@onready var spawn_label: Label = $Spawn_Label
@onready var wave_label: Label = $Wave_Label


func _ready() -> void:
	pass


func create_seed_packets(packets: Array[SeedPacket]) -> void:
	for i in packets.size():
		var p: SeedPacket = packets[i]
		var control: PacketControl = preload("res://scenes/ui_elements/packet_control/packet_control.tscn").instantiate()
		control.name = "SeedPacket_"+str(i)
		control.node_index = i
		control.seed_index = i
		packet_grid.add_child(control)
		
		control.set_plant(p.name)
		control.set_price(p.sun_cost)
		
		control.packet_clicked.connect(packet_clicked)


func update_packets_recharge(charges: Array[float]) -> void:
	for i in charges.size():
		var control: PacketControl = packet_grid.get_child(i)
		control.update_recharge(charges[i])


func set_packet_state(index: int, state: String, value: bool) -> void:
	if packet_grid.get_child_count() < index:
		return
	var control: PacketControl = packet_grid.get_child(index)
	control.set_state(state, value)


func packet_clicked(node_index: int, seed_index: int) -> void:
	plant_button_pressed.emit(node_index, seed_index)


func update_sun_amount(value: int) -> void:
	sun_label.text = "Sun: " + str(value)
