extends Node2D
class_name Sun

signal sun_collected(sun: Sun)

@export var despawn_time: float = 12.0
@export_group("Rotation")
@export var rotation_speed: float = 1
@export var degrees: float = 95
@export var rotation_variation: float = 0.2

@export_group("Movement")
@export var horizontal_speed: float = 0
@export var fall_speed: float = 64
@export var gravity_speed: float = 36
@export var fall_range: float = 176

var value: int = 25

var direction: int = 0
var variation: float = 0
var velocity: Vector2
var start_position: Vector2
var on_the_ground: bool = false

@onready var sprite: Node2D = $Sprite
@onready var sun_ring: Sprite2D = $Sprite/Center/Ring
@onready var collision_shape: CollisionShape2D = $Mouse_Area/Collision_Shape
@onready var despawn_timer: Timer = $Despawn_Timer



func _ready() -> void:
	variation = randf_range(rotation_variation, -rotation_variation)
	start_position = global_position


func _process(delta: float) -> void:
	sun_ring.rotation_degrees += degrees * delta * (rotation_speed + variation)


func _physics_process(delta: float) -> void:
	var traveled = global_position - start_position
	if traveled.y >= fall_range:
		on_the_ground = true
		velocity = Vector2.ZERO
		if despawn_timer.time_left <= 0:
			despawn_timer.start(despawn_time)
	if !on_the_ground:
		if velocity.y == 0:
			velocity.y = fall_speed
		velocity.x = direction * horizontal_speed * delta
		velocity.y += gravity_speed * delta
		
		move(delta)


func move(delta) -> void:
	position += velocity * delta


func _on_mouse_area_mouse_entered() -> void:
	collision_shape.disabled = true
	sun_collected.emit(self)


func _on_despawn_timer_timeout() -> void:
	collision_shape.disabled = true
	var tween := create_tween().tween_property(sprite, "scale", Vector2.ZERO, 0.55).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	queue_free()
