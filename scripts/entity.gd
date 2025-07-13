extends CharacterBody2D
class_name Entity

signal entity_damaged(amount: int)
signal entity_died(entity: Entity)

@export var sprite: EntitySprite
@export var health: int = 100

var cell: Vector2i
var lane: int
var lawn: Lawn

@onready var health_node: HealthNode = %Health_Node
@onready var status_node: StatusManager = %Status_Node
@onready var hitbox: Hitbox = %Hitbox
@onready var components: Node = $Components



func _ready() -> void:
	
	health_node.init(health)
	health_node.damaged.connect(_on_damaged)
	health_node.died.connect(_on_died)
	
	if is_instance_valid(sprite):
		sprite.animation_finished.connect(on_animation_finished)


func on_animation_finished(_anim_name):
	pass


func apply_damage(damage: DamageRef) -> void:
	health_node.decrease_health(damage.value)


func apply_heal(value: int) -> void:
	health_node.increase_health(value)


func _on_damaged(amount: int) -> void:
	entity_damaged.emit(self, amount)


func _on_died() -> void:
	entity_died.emit(self)


func apply_status(status_name: String, type: String, duration: float, context: Dictionary = {}) -> void:
	status_node.apply_status(status_name, type, duration, context)


func remove_status(status_name: String, type: String, context: Dictionary = {}) -> void:
	status_node.remove_status(status_name, type, context)


func remove_statuses_by_type(type: String) -> void:
	status_node.remove_statuses_by_type(type)


func get_status(status_name: String, type: String) -> StatusEffect:
	return status_node.get_status(status_name, type)


func has_status(status_name: String, type: String = "") -> bool:
	return status_node.has_status(status_name, type)


func get_total_value(status_name: String) -> float:
	return status_node.get_total_value(status_name)


func get_total_statcks(status_name: String) -> int:
	return status_node.get_total_statcks(status_name)
