extends Zombie
class_name BasicZombie

@export var armor_sprite: Sprite2D
@export var armor_states := {
	"state_0": "",
	"state_1": "",
	"state_2": ""
}

@onready var movement: ZombieMovement = %Movement
@onready var detect_node: PlantDetectionComponent = %Detect_Node
@onready var attack_cooldown_node: CooldownNode = $Components/Attack_Cooldown_Node
@onready var chomp_node: ChompNode = %Chomp_Node



func _ready() -> void:
	super._ready()
	movement.can_move = true
	attack_cooldown_node.timer = 0
	if is_instance_valid(armor_sprite):
		for state in armor_states:
			if state != "":
				armor_states[state] = load(armor_states[state])
		armor_sprite.texture = armor_states["state_0"]


func _process(_delta: float) -> void:
	if has_status("stunned"):
		sprite.anim.speed_scale = 0.0
		movement.can_move = false
		return
	else:
		if sprite.get_animation() == "walk_cycle" or sprite.get_animation() == "idle":
			var move_multi: float = 1.0
			if has_status("movement_slow"):
				move_multi -= get_total_value("movement_slow")
			if has_status("movement_haste"):
				move_multi += get_total_value("movement_haste")
			sprite.set_anim_speed(move_multi)
		else:
			var attack_multi: float = 1.0
			if has_status("attack_slow"):
				attack_multi -= get_total_value("attack_slow")
			if has_status("attack_haste"):
				attack_multi += get_total_value("attack_haste")
			sprite.set_anim_speed(attack_multi)
	
	if detect_node.has_plant_in_range():
		if sprite.get_animation() == "walk_cycle":
			sprite.play_animation("idle")
		attack_cooldown_node.is_enabled = true
		movement.can_move = false
	else:
		if sprite.get_animation() != "walk_cycle":
			sprite.play_animation("walk_cycle")
		attack_cooldown_node.is_enabled = false
		movement.can_move = true


func attack() -> void:
	var plant: Plant = detect_node.get_closest_plant()
	if plant:
		chomp_node.chomp_plant(plant)


func armor_damaged() -> void:
	if is_instance_valid(armor_sprite):
		if armor_node.current_armor > armor_node.maximum_armor * 0.66:
			armor_sprite.texture = armor_states["state_0"]
		elif armor_node.current_armor > armor_node.maximum_armor * 0.33:
			armor_sprite.texture = armor_states["state_1"]
		else:
			armor_sprite.texture = armor_states["state_2"]


func _on_armor_broke() -> void:
	if is_instance_valid(armor_sprite):
		armor_sprite.visible = false


func _on_attack_cooldown_node_timeout() -> void:
	sprite.play_animation("chomp_0")
	attack_cooldown_node.reset()
