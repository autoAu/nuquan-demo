extends Node2D

@onready var player := $ActorContainer/Player
@onready var camera := $Camera

func _process(delta: float) -> void:
	if player.position.x > camera.position.x:
		camera.position.x = player.position.x
