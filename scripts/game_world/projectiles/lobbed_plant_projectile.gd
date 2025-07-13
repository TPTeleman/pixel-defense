extends PlantProjectile
class_name LobbedPlantProjectile

@export var rotation_speed: float

var end_pos: Vector2
var height: int = 52
var t: float = 0.0
var duration: float = 0.65
var reached_end: bool = false
var rotation_variation: float = 1.0



func _ready() -> void:
	super._ready()
	rotation_degrees += randf_range(-rotation_speed, rotation_speed)
	rotation_variation += randf_range(-0.3, 0.8)


func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta * rotation_variation


func _physics_process(delta: float) -> void:
	if end_pos == Vector2.ZERO:
		return
	if t < 1:
		t = min(t+delta/duration, 1)
		position.x = lerpf(starting_pos.x, end_pos.x, t)
		position.y = lerpf(starting_pos.y, end_pos.y, t)
		position.y += height*(-1+4*pow((t-0.5), 2))
	elif !reached_end:
		on_reached_end()


func on_reached_end() -> void:
	reached_end = true
	queue_free()


func on_hit_zombie(zombie: Zombie) -> void:
	on_reached_end()
	super.on_hit_zombie(zombie)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var hitbox = area as Hitbox
		var body: Entity = hitbox.body
		if body is Zombie:
			var zombie: Zombie = hitbox.body
			if zombie.lane == lane and !reached_end:
				on_hit_zombie(zombie)
