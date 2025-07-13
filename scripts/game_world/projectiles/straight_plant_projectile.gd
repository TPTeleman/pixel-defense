extends PlantProjectile
class_name StraightPlantProjectile

@export var projectile_speed: float = 180
@export var pierce_amount: int = 0
@export var infinite_pierce: bool = false
@export var projectile_range: float = 0
@export var range_limit: bool = false

var pierce_count: int
var direction: Vector2 = Vector2(1, 0)
var traveled_distance: float = 0



func _ready() -> void:
	super._ready()
	pierce_count = pierce_amount


func _process(_delta) -> void:
	if range_limit:
		traveled_distance = starting_pos.distance_to(global_position)
	if (range_limit and traveled_distance >= projectile_range) or (!infinite_pierce and pierce_count <= 0):
		queue_free()


func _physics_process(delta) -> void:
	velocity = direction * projectile_speed
	move(delta)


func move(delta) -> void:
	position += velocity * delta


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var hitbox = area as Hitbox
		var body: Entity = hitbox.body
		if body is Zombie:
			var zombie: Zombie = hitbox.body
			if zombie.lane == lane and (pierce_count > 0 or infinite_pierce):
				on_hit_zombie(zombie)


func on_hit_zombie(zombie: Zombie) -> void:
	pierce_count -= 1
	super.on_hit_zombie(zombie)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
