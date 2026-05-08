extends CharacterBody2D

@export var health : int
@export var damage : int
@export var speed : float

@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $CharacterSprite

enum State {IDLE, WALK, ATTACK}

var state = State.IDLE

func _process(delta: float) -> void:
	flip_sprite()
	handle_movement()
	handle_animations()
	handle_input()
	move_and_slide()

func handle_movement() -> void:
	if can_move():
		if velocity.length() == 0:
			state =State.IDLE
		else:
			state = State.WALK

func handle_input() -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if can_attack() and Input.is_action_just_pressed("attack"):
		state = State.ATTACK

func handle_animations() -> void:
	if state == State.IDLE:
		animation_player.play("idle")
	elif state == State.WALK:
		animation_player.play("walk")
	elif state == State.ATTACK:
		animation_player.play("punch")
		
func flip_sprite() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = false
	elif velocity.x < 0:
		character_sprite.flip_h = true
		
func can_move() -> bool:
	return state == State.IDLE or state == State.WALK

func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK

func on_action_complete() -> void:
	state = State.IDLE
