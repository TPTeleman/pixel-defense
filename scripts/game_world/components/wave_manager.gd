extends Node
class_name WaveManager

const ZOMBIE_COST := {
"basic_zombie": 1,
"conehead_zombie": 2,
"buckethead_zombie": 4,
"screendoor_zombie": 3,
}

var current_zombies: Array[Zombie]
var max_wave_health: float = 0.0
var current_wave_health: float = 0.0
var wave_advanced: bool = false

var wave_number = 0
var current_wave: WaveData
var spawn_queue: Array[String] = []

var delay_timer: Timer
var elapsed_time: float = 0.0
var next_wave_time: float = 0.0
var spawn_cooldown: float = 0.0
var wave_budget: int = 0

var can_spawn: bool = false

@onready var lawn: Lawn = get_node("../..")
@onready var grid: GridLawn = lawn.grid
@onready var zombie_manager: ZombieManager = lawn.zombie_manager


func _ready() -> void:
	delay_timer = Timer.new()
	delay_timer.one_shot = true
	delay_timer.name = "Delay_Timer"
	add_child(delay_timer)


func on_start_level(delay: float) -> void:
	wave_number = -1
	wave_advanced = false
	stop_tracking_all_zombies()
	spawn_queue.clear()
	
	delay_timer.start(delay)
	await delay_timer.timeout
	
	get_next_wave()
	can_spawn = true


func _process(delta: float) -> void:
	if !can_spawn or spawn_queue.is_empty():
		return
	
	elapsed_time += delta
	spawn_cooldown -= delta
	
	if spawn_cooldown <= 0:
		spawn_zombie()
	
	if elapsed_time >= next_wave_time:
		get_next_wave()


func spawn_zombie() -> void:
	spawn_cooldown = current_wave.spawn_rate
	
	if spawn_queue.is_empty():
		return
	
	var type: String = spawn_queue.pop_front()
	var cell := Vector2i(10, randi()%5)
	
	var zombie: Zombie = zombie_manager.spawn_zombie(type, cell)
	zombie.entity_died.connect(_on_zombie_died)
	zombie.entity_damaged.connect(_on_zombie_damaged)
	current_zombies.append(zombie)


func get_next_wave() -> void:
	var waves: Array[WaveData] = lawn.level.waves
	
	stop_tracking_all_zombies()
	wave_advanced = false
	
	if wave_number + 1 < waves.size():
		current_wave = waves[wave_number + 1]
		elapsed_time = 0.0
		next_wave_time = lawn.level.wave_duration
		spawn_cooldown = current_wave.spawn_rate
		wave_budget = current_wave.budget
		wave_number += 1
		build_wave()
		spawn_zombie()
		return


func build_wave() -> void:
	current_zombies.clear()
	max_wave_health = 0
	current_wave_health = 0
	
	while wave_budget > 0:
		var affordable = get_affordable_zombies(current_wave.zombie_pool)
		if affordable.is_empty():
			break
		
		var type = affordable.pick_random()
		spawn_queue.append(type)
		wave_budget -= ZOMBIE_COST[type]
		
		var hp: int = zombie_manager.get_zombie_scene(type).health
		max_wave_health += hp
		current_wave_health += hp


func _on_zombie_damaged(zombie: Entity, amount: int) -> void:
	if !is_instance_valid(zombie) or !current_zombies.has(zombie):
		return
	current_wave_health -= amount
	
	if current_wave_health < max_wave_health / 2 and !wave_advanced:
		wave_advanced = true
		elapsed_time = next_wave_time * 0.9


func _on_zombie_died(zombie: Entity) -> void:
	if !is_instance_valid(zombie) or !current_zombies.has(zombie):
		return
	
	if current_zombies.size() <= 0 and spawn_queue.size() > 0:
		spawn_cooldown /= 2 + roundi(float(wave_number) / 10)
	
	stop_tracking_zombie(zombie)


func stop_tracking_all_zombies() -> void:
	for zombie in current_zombies:
		stop_tracking_zombie(zombie)


func stop_tracking_zombie(zombie: Zombie) -> void:
	current_zombies.erase(zombie)
	zombie.entity_died.disconnect(_on_zombie_died)
	zombie.entity_damaged.disconnect(_on_zombie_damaged)


func get_affordable_zombies(pool: Array[String]) -> Array[String]:
	return pool.filter(func(z) -> bool: return ZOMBIE_COST[z] <= wave_budget)
