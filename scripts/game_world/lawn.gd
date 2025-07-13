extends Node2D
class_name Lawn

var level: LevelData

var seed_packets: Array[SeedPacket]
var seed_inventory: Array[SeedPacket]

var mouse_pos: Vector2
var hover_cell: Vector2i
var cell_pos: Vector2i

var selected_packet_node: int = -1
var selected_seed: SeedPacket = null
var mouse_plant: Plant = null
var preview_plant: Plant = null

var level_started: bool = false
var sun_amount: int = 0

var plants_per_lane := {}
var zombies_per_lane := {}

@export_group("Components")
@export var grid: GridLawn
@export var entity_factory: EntityFactory
@export var input_manager: InputManager
@export var sun_factory: SunFactory
@export var plant_manager: PlantManager
@export var zombie_manager: ZombieManager
@export var wave_manager: WaveManager

@onready var gui: GUI = %GUI

@onready var plants: Node2D = %Plants
@onready var zombies: Node2D = %Zombies
@onready var objects: Node2D = %Objects
@onready var highlight: Sprite2D = %Highlight



func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if !level_started:
		return
	
	handle_seed_recharge(delta)
	if wave_manager.can_spawn:
		gui.spawn_label.text = "Timer: %ds" % wave_manager.elapsed_time
	else:
		gui.spawn_label.text = "Timer: %ds" % wave_manager.delay_timer.time_left
	gui.wave_label.text = "Wave: %d/%d" % [wave_manager.current_wave_health, wave_manager.max_wave_health]
	
	mouse_pos = get_global_mouse_position()
	hover_cell = grid.pos_to_cell(mouse_pos)
	cell_pos = grid.cell_to_pos(hover_cell)
	
	highlight.position = cell_pos
	if is_instance_valid(mouse_plant):
		mouse_plant.position = mouse_pos+Vector2(12, 16)
	if is_instance_valid(preview_plant):
		preview_plant.position = cell_pos
		preview_plant.visible = plant_manager.cell_can_plant(selected_seed, hover_cell)


func enter_level(_level: LevelData) -> void:
	level = _level
	
	sun_factory.set_up_timers(level)
	sun_factory.set_sun(level.starting_sun)
	
	grid.create_grid()
	for lane in grid.grid_size.y:
		plants_per_lane[lane] = []
		zombies_per_lane[lane] = []


func start_level(seeds: Array[SeedPacket]) -> void:
	level_started = true
	sun_factory.can_produce = level.sun_falls
	wave_manager.on_start_level(level.wave_delay)
	
	seed_inventory = seeds
	
	for i in seed_inventory.size():
		var packet: SeedPacket = seed_inventory[i].duplicate()
		seed_inventory[i] = packet
		packet.current_charge = packet.start_cooldown
	gui.create_seed_packets(seed_inventory)
	handle_seed_cost()


func handle_seed_recharge(delta) -> void:
	var charges: Array[float]
	for packet in seed_inventory:
		if packet.current_charge > 0:
			packet.current_charge -= delta
		var charge: float = float(packet.current_charge)/float(packet.recharge)
		charges.append(charge * 100)
	
	gui.update_packets_recharge(charges)


func handle_seed_cost() -> void:
	for i in seed_inventory.size():
		var packet: SeedPacket = seed_inventory[i]
		gui.set_packet_state(i, "disabled", sun_amount < packet.sun_cost)


func get_zombies_in_lane(lane: int) -> Array[Zombie]:
	var array: Array[Zombie]
	array.assign(zombies_per_lane.get(lane, []))
	return array


func get_plants_in_lane(lane: int) -> Array[Plant]:
	var array: Array[Plant]
	array.assign(plants_per_lane.get(lane, []))
	return array
