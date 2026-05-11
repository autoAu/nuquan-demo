class_name Collectible
extends Area2D

const GRAVITY := 600.0

@export var speed : float
@export var knockdown_intensity : float
@export var type : Type
@export var damage : int

@onready var collectible_sprite : Sprite2D = $CollectibleSprite
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var damage_emitter : Area2D = $DamageEmitter

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
var direction := Vector2.ZERO
var velocity := Vector2.ZERO

func _ready() -> void:
	height_speed = knockdown_intensity
	if state == State.FLY:
		velocity = direction * speed
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	damage_emitter.body_exited.connect(on_exit_screen.bind())
	damage_emitter.position = Vector2.UP * height

func _process(delta: float) -> void:
	handle_fall(delta)
	handle_animation()
	collectible_sprite.flip_h = velocity.x < 0
	collectible_sprite.position = Vector2.UP * height
	position += velocity * delta
	
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

func on_emit_damage(receiver : DamageReceiver) -> void:
	receiver.damage_received.emit(damage, direction, DamageReceiver.HitType.KNOCKDOWN)
	queue_free()

func on_exit_screen(wall: AnimatableBody2D) -> void:
	queue_free()
