extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

enum {
	IDLE,
	WANDER,
	KNOCKBACK,
	CHASE
}

var state = IDLE
var knockback = Vector2.ZERO
@export var KNOCKBACK_AMMOUNT = 500
@export var FRICTION = 0.8

@onready var stats = $Stats

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
		WANDER:
			pass
		KNOCKBACK:
			knockback_state()
		CHASE:
			pass

func knockback_state():
	var modVelocity = velocity.length_squared() # Funciona pero es muy ineficiente, pensar alternativa
	print("modVelocity")
	if modVelocity != 0:
		velocity *= FRICTION
		move_and_slide()
	else:
		state = IDLE

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK_AMMOUNT
	velocity = knockback
	state = KNOCKBACK

func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
