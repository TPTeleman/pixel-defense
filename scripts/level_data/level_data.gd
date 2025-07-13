extends Resource
class_name LevelData

@export var waves: Array[WaveData]

@export_group("Wave Details")
@export var wave_delay: float = 30.0
@export var wave_duration: float = 45.0

@export_group("Sun Details")
@export var sun_falls: bool = true
@export var starting_sun: int = 50
@export var first_sun_delay: float = 4.5
@export var sun_delay: float = 16.0
@export var sun_power: int = 25
@export var first_sun_needed: int = 1
