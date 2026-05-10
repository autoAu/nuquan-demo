class_name BasicEnemy
extends Character

@export var duration_between_hit : int
@export var duration_prep_hit : int
@export var player : Player

var player_slot : EnemySlot = null
var Time_since_last_hit := Time.get_ticks_msec()
var Time_since_prep_hit := Time.get_ticks_msec()

func _ready() -> void:
	super._ready()
	anim_attack = ["punch", "punch_alt",]

func handle_input() -> void:
	if player != null and can_move():
		
		if player_slot == null:
			player_slot = player.reserve_slot(self)
		
		if player_slot != null:
			var direction =(player_slot.global_position - global_position).normalized()
			if is_player_within_rangr():
				velocity = Vector2.ZERO
				if can_attack():
					state = State.PREP_ATTACK
					Time_since_prep_hit = Time.get_ticks_msec()
			else:
				velocity = direction * speed

func handle_prep_attack() -> void:
	if state == State.PREP_ATTACK and (Time.get_ticks_msec() - Time_since_prep_hit) > duration_prep_hit:
		state = State.ATTACK
		Time_since_last_hit = Time.get_ticks_msec()
		anim_attack.shuffle()

func is_player_within_rangr() -> bool:
	return (player_slot.global_position - global_position).length() < 1

func can_attack() -> bool:
	if Time.get_ticks_msec() - Time_since_last_hit < duration_between_hit:
		return false
	return super.can_attack()

func set_heading() -> void:
	if player == null or [State.DEATH, State.GROUNDED].has(state):
		return
	heading = Vector2.LEFT if position.x > player.position.x else Vector2.RIGHT

func on_receive_damage(amount: int, direction: Vector2, hit_type: DamageReceiver.HitType) -> void:
	super.on_receive_damage(amount, direction, hit_type)
	if current_health == 0:
		player.free_slot(self)
