class_name Collctible
extends Area2D

const GRAVITY := 600.0

@export var speed : float
@export var knockdown_intensity : float
@export var type : Type

@onready var collectible_sprite : Sprite2D = $CollctibleSprite
@onready var animation_player : AnimationPlayer = $AnimationPlayer


enum State {FALL, GROUNDED, FLY}
enum Type {KNIFE, GUN, FOOD}

var anim_map := {
	State.FALL: "fall",
	State.GROUNDED: "grounded",
	State.FLY: "fly",
}
var height : float
var height_speed : float
var state = State.FALL

func _ready() -> void:
	height_speed = knockdown_intensity
	
func _process(delta: float) -> void:
	handle_fall(delta)
	handle_animation()
	collectible_sprite.position = Vector2.UP * height
	
func handle_animation() -> void:
	animation_player.play(anim_map[state])

func handle_fall(delta: float) -> void:
	if state == State.FALL:
		height += height_speed * delta
		if height < 0:
			height = 0
			state = State.GROUNDED
		else:
			height_speed -= GRAVITY * delta
