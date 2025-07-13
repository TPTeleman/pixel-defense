extends Plant

const ANIM_CYCLE := {
	"pre_action": "action",
	"action": "idle"
}

var is_ready: bool = false

@onready var cooldown_node: CooldownNode = %Cooldown_Node
@onready var detect_node: ZombieDetectNode = %Detect_Node
@onready var shooter_node: PlantShooterNode = %Shooter_Node



func on_plant() -> void:
	super.on_plant()
	cooldown_node.is_enabled = true


func _process(_delta: float) -> void:
	if is_ready and detect_node.has_zombie_in_range():
		is_ready = false
		sprite.play_animation("pre_action")


func on_animation_finished(anim_name):
	if ANIM_CYCLE.has(anim_name):
		sprite.play_animation(ANIM_CYCLE[anim_name])
	if anim_name == "action":
		cooldown_node.reset()


func shoot() -> void:
	var arr := await shooter_node.shoot()
	for proj: StraightPlantProjectile in arr:
		proj.splash_damage = 10


func _on_cooldown_node_timeout() -> void:
	is_ready = true
