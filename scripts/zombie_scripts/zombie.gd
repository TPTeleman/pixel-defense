extends Entity
class_name Zombie

@export var armor: int = 0
@export_enum("plastic","metal","brick") var armor_type: String
@export var forearm_sprite: Sprite2D

var armor_node: ArmorComponent

@onready var arm_fall: GPUParticles2D = $Arm_Fall



func _ready() -> void:
	super._ready()
	if armor > 0:
		armor_node = ArmorComponent.new()
		armor_node.name = "Armor_Node"
		armor_node.init(armor)
		health_node.add_child(armor_node)
		armor_node.broke.connect(_on_armor_broke)


func apply_damage(damage: DamageRef) -> void:
	var amount := damage.value
	if is_instance_valid(armor_node) and !armor_node.is_broken:
		amount = armor_node.decrease_armor(amount)
		armor_damaged()
	
	if amount > 0:
		health_node.decrease_health(amount)
		if forearm_sprite != null and forearm_sprite.visible and health_node.current_health <= health_node.maximum_health * 0.5:
			lose_arm()


func lose_arm() -> void:
	forearm_sprite.visible = false
	arm_fall.emitting = true


func armor_damaged() -> void:
	pass


func _on_armor_broke() -> void:
	pass
