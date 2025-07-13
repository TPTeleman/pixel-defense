extends Node

@export var seed_inventory: Array[SeedPacket]
@export var level_data: LevelData

@onready var lawn: Lawn = $Lawn



func _ready() -> void:
	lawn.enter_level(level_data)
	await get_tree().process_frame
	lawn.start_level(seed_inventory)
