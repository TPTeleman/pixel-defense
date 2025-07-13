extends Control
class_name PacketControl

signal packet_clicked(node_index: int, seed_index: int)

var node_index: int = -1
var seed_index: int = -1

var states := {
	"selected": false,
	"hovered": false,
	"disabled": false,
}

@onready var packet_background: TextureRect = %Packet_Background
@onready var packet_plant: TextureRect = %Packet_Plant

@onready var cost_label: Label = %Cost_Label
@onready var recharge_bar: TextureProgressBar = %Recharge_Bar
@onready var disable_overlay: TextureRect = %Disable_Overlay
@onready var select_overlay: TextureRect = %Select_Overlay



func _ready() -> void:
	set_plant("peashooter")
	set_price(0)
	update_recharge(0)
	set_state("selected", false)
	set_state("hovered", false)
	set_state("disabled", false)


func set_plant(plant: String, background: String = "default") -> void:
	packet_plant.texture = load("res://sprites/seed_packets/plant_icons/packet_"+ plant +".png")
	packet_background.texture = load("res://sprites/seed_packets/background_textures/background_"+ background +".png")


func set_price(value: int) -> void:
	cost_label.text = str(value)


func update_recharge(value: float) -> void:
	recharge_bar.value = value


func set_state(state: String, value: bool) -> void:
	states[state] = value
	
	select_overlay.visible = states.selected
	disable_overlay.visible = states.disabled
	cost_label.self_modulate = Color("ffffff") if !states.disabled else Color("ff0000")
	
	if state == "disabled" and value == true:
		set_state("selected", false)
		set_state("hovered", false)


func _process(_delta: float) -> void:
	if states.hovered:
		pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if states.disabled:
			return
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				packet_clicked.emit(node_index, seed_index)


func _on_mouse_entered() -> void:
	if !states.disabled:
		set_state("hovered", true)


func _on_mouse_exited() -> void:
	if states.hovered:
		set_state("hovered", false)
