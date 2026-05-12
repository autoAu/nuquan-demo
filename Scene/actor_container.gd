extends Node2D

const PREFAB_SHOT := preload("res://props/shot.tscn")
const PREFAB_MAP := {
	Collectible.Type.KNIFE: preload("res://props/knife.tscn")
}


func _ready() -> void:
	EntityManager.spawn_collectible.connect(on_spawn_collectible.bind())
	EntityManager.spawn_shot.connect(on_spawn_shot.bind())

func on_spawn_collectible(type: Collectible.Type, initial_state: Collectible.State, collectible_global_position: Vector2, collectible_direction: Vector2, initial_height: float) -> void:
	var collectible: Collectible = PREFAB_MAP[type].instantiate()
	collectible.state = initial_state
	collectible.height = initial_height
	collectible.global_position = collectible_global_position
	collectible.direction = collectible_direction
	add_child(collectible)

func on_spawn_shot(gun_root_position: Vector2, distance_traveled: float, height: float) -> void:
	var shot : Shot = PREFAB_SHOT.instantiate()
	add_child(shot)
	shot.position = gun_root_position
	shot.initialize(distance_traveled, height)
