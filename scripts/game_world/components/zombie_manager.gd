extends Node
class_name ZombieManager

@onready var lawn: Lawn = get_node("../..")
@onready var grid: GridLawn = lawn.grid
@onready var entity_factory: EntityFactory = lawn.entity_factory



func _ready() -> void:
	pass


func get_zombie_scene(type: String) -> Zombie:
	var scene := load("res://scenes/zombies/"+type+"/"+type+"_node.tscn")
	var zombie: Zombie = scene.instantiate()
	return zombie


func spawn_zombie(type: String, cell: Vector2i) -> Zombie:
	var pos = grid.cell_to_pos(cell)
	var scene := load("res://scenes/zombies/"+type+"/"+type+"_node.tscn")
	var zombie := entity_factory.create_zombie(scene, pos, cell)
	zombie.lawn = lawn
	lawn.zombies.call_deferred("add_child", zombie)
	
	zombie.entity_died.connect(_on_zombie_died)
	lawn.zombies_per_lane[zombie.lane].append(zombie)
	
	return zombie


func _on_zombie_died(z: Zombie) -> void:
	lawn.zombies_per_lane[z.lane].erase(z)
	z.call_deferred("queue_free")
