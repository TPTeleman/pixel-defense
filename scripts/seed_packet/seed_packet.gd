extends Resource
class_name SeedPacket

@export var name: String
@export var plant: PackedScene
@export var sun_cost: int = 0
@export var start_cooldown: float = 0
@export var recharge: float = 0

@export_category("Placement Details")
@export var is_upgrade: bool = false
@export_enum("takes_space","is_hollow","is_floor") var placement_tags: int = 0
@export_flags("dirt","rock","water") var cell_type: int = 1

var current_charge: float = 0



func enter_cooldown() -> void:
	current_charge = recharge
