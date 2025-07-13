extends Plant

const ANIM_CYCLE := {
	"pre_action": "action",
	"action": "idle"
}

@onready var cooldown_node: CooldownNode = %Cooldown_Node
@onready var sun_maker_node: SunMakerNode = %Sun_Maker_Node



func on_plant() -> void:
	super.on_plant()
	cooldown_node.is_enabled = true
	sun_maker_node.sun_factory = lawn.sun_factory


func on_animation_finished(anim_name):
	if ANIM_CYCLE.has(anim_name):
		sprite.play_animation(ANIM_CYCLE[anim_name])
	if anim_name == "action":
		cooldown_node.reset()


func make_sun() -> void:
	sun_maker_node.create_sun()


func _on_cooldown_node_timeout() -> void:
	sprite.play_animation("pre_action")
